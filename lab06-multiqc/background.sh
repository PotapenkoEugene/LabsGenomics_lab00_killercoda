#!/bin/bash
set -e

RAW=https://raw.githubusercontent.com/PotapenkoEugene/LabsGenomics_lab00_killercoda/main/lab06-data

# ── Install micromamba ───────────────────────────────────────────────────────
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
  | tar -xj bin/micromamba
mv bin/micromamba /usr/local/bin/micromamba && rmdir bin
chmod +x /usr/local/bin/micromamba

export MAMBA_ROOT_PREFIX=/opt/micromamba

# ── Create bio environment ───────────────────────────────────────────────────
micromamba create -y -n bio -c bioconda -c conda-forge \
  fastp fastqc bwa-mem2 samtools multiqc 2>&1 | tail -3

# ── Create student user ──────────────────────────────────────────────────────
id student 2>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd

# ── Student shell setup ──────────────────────────────────────────────────────
cat >> /home/student/.bashrc << 'EOF'
export MAMBA_ROOT_PREFIX=/opt/micromamba
eval "$(micromamba shell hook -s bash)"
micromamba activate bio
EOF

cat > /home/student/.bash_profile << 'EOF'
[ -f ~/.bashrc ] && source ~/.bashrc
cd ~/labs/lab06 2>/dev/null || true
EOF

chown student:student /home/student/.bashrc /home/student/.bash_profile

# ── Pre-stage full pipeline output (Tasks 1 + 2) ────────────────────────────
mkdir -p /home/student/labs/lab06

wget -q "$RAW/sample1.fastq.gz" -O /tmp/sample1.fastq.gz
wget -q "$RAW/sample2.fastq.gz" -O /tmp/sample2.fastq.gz
wget -q "$RAW/sars_cov2.fna"    -O /home/student/labs/lab06/sars_cov2.fna

# Trim
micromamba run -n bio fastp \
  -i /tmp/sample1.fastq.gz \
  -o /home/student/labs/lab06/sample1_clean.fastq.gz \
  -j /home/student/labs/lab06/sample1_fastp.json \
  -h /home/student/labs/lab06/sample1_fastp.html \
  2>/dev/null

micromamba run -n bio fastp \
  -i /tmp/sample2.fastq.gz \
  -o /home/student/labs/lab06/sample2_clean.fastq.gz \
  -j /home/student/labs/lab06/sample2_fastp.json \
  -h /home/student/labs/lab06/sample2_fastp.html \
  2>/dev/null

# FastQC
micromamba run -n bio fastqc \
  /home/student/labs/lab06/sample1_clean.fastq.gz \
  /home/student/labs/lab06/sample2_clean.fastq.gz \
  --outdir /home/student/labs/lab06/ \
  2>/dev/null

# Index + align
cd /home/student/labs/lab06
micromamba run -n bio bwa-mem2 index sars_cov2.fna 2>/dev/null
micromamba run -n bio bwa-mem2 mem sars_cov2.fna sample1_clean.fastq.gz \
  > sample1_clean.sam 2>/dev/null
micromamba run -n bio bwa-mem2 mem sars_cov2.fna sample2_clean.fastq.gz \
  > sample2_clean.sam 2>/dev/null

chown -R student:student /home/student/labs

# ── Report viewer helper ─────────────────────────────────────────────────────
cat > /home/student/view-reports.sh << 'EOF'
#!/bin/bash
pkill -f "http.server 8080" 2>/dev/null || true
cd ~/labs/lab06 || exit 1
python3 -m http.server 8080 >/dev/null 2>&1 &
echo "Reports served. Open the link shown in the step instructions (port 8080)."
EOF
chmod +x /home/student/view-reports.sh
chown student:student /home/student/view-reports.sh

touch /tmp/setup_done
