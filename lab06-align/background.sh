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
  fastp bwa-mem2 samtools 2>&1 | tail -3

# ── Activate in student shell ────────────────────────────────────────────────
echo 'export MAMBA_ROOT_PREFIX=/opt/micromamba'      >> /root/.bashrc
echo 'eval "$(micromamba shell hook -s bash)"'        >> /root/.bashrc
echo 'micromamba activate bio'                        >> /root/.bashrc

# ── Stage raw inputs at instructor path ─────────────────────────────────────
mkdir -p /home/evgenip/labs/lab06
mkdir -p /root/labs/lab06

wget -q "$RAW/sample1.fastq.gz" -O /home/evgenip/labs/lab06/sample1.fastq.gz
wget -q "$RAW/sample2.fastq.gz" -O /home/evgenip/labs/lab06/sample2.fastq.gz
wget -q "$RAW/sars_cov2.fna"    -O /home/evgenip/labs/lab06/sars_cov2.fna

# ── Pre-stage trimmed files (output of Task 1) ───────────────────────────────
eval "$(micromamba shell hook -s bash)"
micromamba activate bio

cd /root/labs/lab06

fastp \
  -i /home/evgenip/labs/lab06/sample1.fastq.gz \
  -o sample1_clean.fastq.gz \
  -j sample1_fastp.json -h sample1_fastp.html \
  2>/dev/null

fastp \
  -i /home/evgenip/labs/lab06/sample2.fastq.gz \
  -o sample2_clean.fastq.gz \
  -j sample2_fastp.json -h sample2_fastp.html \
  2>/dev/null

# ── Report viewer helper ─────────────────────────────────────────────────────
cat > /root/view-reports.sh << 'EOF'
#!/bin/bash
pkill -f "http.server 8080" 2>/dev/null || true
cd ~/labs/lab06 || exit 1
python3 -m http.server 8080 >/dev/null 2>&1 &
echo "Reports served. Open the link shown in the step instructions (port 8080)."
EOF
chmod +x /root/view-reports.sh
