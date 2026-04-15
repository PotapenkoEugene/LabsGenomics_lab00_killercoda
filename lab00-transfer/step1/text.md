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

## Part C — Download somewhere else, then move it

Not every download lands where you want it. Go back to your home directory and download the genome FASTA from the same NCBI entry:

```bash
cd ~
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

The file landed in `~`. Move it into the `ecoli` directory:

```bash
mv GCF_000005845.2_ASM584v2_genomic.fna.gz ~/lab00/ecoli/
```

Confirm both files are together:

```bash
ls -lh ~/lab00/ecoli/
```

Click **Check** to verify.
