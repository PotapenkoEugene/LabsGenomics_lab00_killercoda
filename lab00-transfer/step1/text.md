# Download with wget

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Create a directory for E. coli data

You'll download two files from NCBI. First, make a directory to keep them organised:

```bash
mkdir -p ~/lab00/ecoli
```

---

## Part B — Download into a directory

Move into the directory and download the assembly statistics file for *E. coli* K-12:

```bash
cd ~/lab00/ecoli
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_assembly_stats.txt
```

`wget` prints progress and saves the file in the current directory. Check it arrived:

```bash
ls -lh
```

---

## Part C — Control the output filename with `-O`

NCBI filenames are long and machine-generated. Download the genome FASTA from the same entry:

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

The saved filename is identical to the URL basename — not great. Delete it and re-download with a clean name using `-O`:

```bash
rm GCF_000005845.2_ASM584v2_genomic.fna.gz
wget -O ecoli_genome.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

Confirm both files are in place:

```bash
ls -lh ~/lab00/ecoli/
```

Click **Check** to verify.
