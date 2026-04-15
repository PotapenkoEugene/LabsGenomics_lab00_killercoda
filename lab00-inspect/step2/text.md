# Read Compressed Files with zcat

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Download the genome FASTA (gzipped)

Move into your working directory:

```bash
cd ~/lab00/inspect
```

Download the *E. coli* K-12 genome sequence — this time it stays compressed:

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

---

## Part B — Identify the file type

```bash
file GCF_000005845.2_ASM584v2_genomic.fna.gz
```

Output: `gzip compressed data` — this is binary. **Do not `cat` it** — it would garble your terminal and print nothing useful.

> **Tip — `file` examines content, not the filename.** Even if someone renames `genome.gz` to `genome.fasta`, `file` still tells you the truth.

---

## Part C — Read without unpacking: zcat

`zcat` decompresses on the fly and streams the output — nothing is written to disk.

Read just the first 3 lines:

```bash
zcat GCF_000005845.2_ASM584v2_genomic.fna.gz | head -3
```

You will see a FASTA header line (starting with `>`) followed by the first lines of DNA sequence.

---

## Part D — Compare sizes: compressed vs plain text

You already have the uncompressed annotation from Step 1. Compare:

```bash
ls -lh ~/lab00/inspect/
```

The `.fna.gz` is around 1.4 MB. The uncompressed `.gff` is around 5 MB. Genomics files compress 3–10× — always keep and transfer data as `.gz`.

---

## Part E — Compress a file with gzip -k

The `-k` flag compresses the file but **keeps the original**. Try it on the annotation:

```bash
gzip -k GCF_000005845.2_ASM584v2_genomic.gff
ls -lh GCF_000005845.2_ASM584v2_genomic.gff GCF_000005845.2_ASM584v2_genomic.gff.gz
```

Without `-k`, `gzip` removes the original — useful when disk is tight, risky when you still need the plain-text version.

---

## Part F — Mark your progress

```bash
touch ~/lab00/inspect/done_zcat.txt
```

Click **Check** to verify.
