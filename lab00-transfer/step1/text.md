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

> **Tip — the `-p` flag.** Without `-p`, `mkdir` fails if any parent directory in the path doesn't exist yet. With `-p`, it creates every missing directory in one go — and stays silent if the directory already exists.

---

## Part B — Download into a directory

Move into the directory and download the genome assembly statistics file for *E. coli* K-12:

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

NCBI filenames are long and machine-generated. Download the same assembly statistics file again, but this time give it a clean name using `-O`:

```bash
wget -O ecoli_stats.txt https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_assembly_stats.txt
```

`-O` sets the output filename regardless of what the URL says. Confirm both files are in place:

```bash
ls -lh ~/lab00/ecoli/
```

Click **Check** to verify.
