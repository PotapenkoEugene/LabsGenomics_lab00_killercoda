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

Confirm it is there:

```bash
ls -lh
```

---

## Part B — Identify the file type

```bash
file GCF_000005845.2_ASM584v2_genomic.gff
```

Output should say `ASCII text`. Good — it is a text file and safe to read. But how large?

---

## Part C — Count lines before you open it

```bash
wc -l GCF_000005845.2_ASM584v2_genomic.gff
```

> **Tip — why count first?**
> `cat` on a 50,000-line file will scroll for seconds and lock your terminal. `wc -l` tells you the size in milliseconds — then you can decide whether `cat` is safe or not.

---

## Part D — Preview safely with head and tail

Look at the first 5 lines:

```bash
head -5 GCF_000005845.2_ASM584v2_genomic.gff
```

The `##gff-version 3` header tells you the format. Now look at the last 3 lines:

```bash
tail -3 GCF_000005845.2_ASM584v2_genomic.gff
```

> **Tip — `head` and `tail` are your safe default.** When you open an unfamiliar file for the first time, always start with `head -5`. You learn the format in seconds without risk.

---

## Part E — Mark your progress

```bash
touch ~/lab00/inspect/inspected.txt
```

Click **Check** to verify.
