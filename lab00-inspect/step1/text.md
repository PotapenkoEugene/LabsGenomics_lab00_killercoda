# Inspect a Big Text File Safely

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Download and unpack the annotation file

Create a directory for this exercise and move into it:

```bash
mkdir -p ~/lab00/inspect
cd ~/lab00/inspect
```

Download the *E. coli* K-12 genome annotation in GFF format (gzipped):

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
```

Unpack it to get a plain-text file:

```bash
gunzip GCF_000005845.2_ASM584v2_genomic.gff.gz
```

```bash
ls -lh
```

---

## Part B — Identify the file type

```bash
file GCF_000005845.2_ASM584v2_genomic.gff
```

Output: `ASCII text` — plain text, safe to read. But how many lines does it have?

---

## Part C — Count lines

```bash
wc -l GCF_000005845.2_ASM584v2_genomic.gff
```

Tens of thousands of lines. Now try opening it anyway:

```bash
cat GCF_000005845.2_ASM584v2_genomic.gff
```

Press **Ctrl+C** to stop it. This is what happens when you `cat` a file without checking its size first — the terminal scrolls for seconds and you learn nothing. If your prompt looks garbled, type `reset` and press Enter.

---

## Part D — Preview with head and tail

Look at the first 5 lines:

```bash
head -5 GCF_000005845.2_ASM584v2_genomic.gff
```

The header lines starting with `#!` contain metadata about this file — including the genome build name on the `#!genome-build` line.

Look at the last 3 lines:

```bash
tail -3 GCF_000005845.2_ASM584v2_genomic.gff
```

> **Tip — always start with `head -5`.** You learn the file format in seconds, with no risk of flooding your terminal.

---

## Part E — Task

The genome build name is in the header you just read. Create an empty file whose name is that build identifier:

```bash
touch ~/lab00/inspect/ASM584v2.txt
```

Click **Check** to verify.
