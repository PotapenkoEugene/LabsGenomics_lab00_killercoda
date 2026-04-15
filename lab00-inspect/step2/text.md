# Read Compressed Files with zcat

## Part A — Create a small compressed file

You still have the annotation file from the previous step. Make a tiny sample from it and compress it:

```bash
cd ~/lab00/inspect
head -20 GCF_000005845.2_ASM584v2_genomic.gff > sample.gff
gzip -k sample.gff
ls -lh sample.gff sample.gff.gz
```

(`-k` keeps the original alongside the compressed copy.)

---

## Part B — What happens when you cat a .gz file?

Try it:

```bash
cat sample.gff.gz
```

Binary garbage — the file is intact, but `cat` has no idea it is compressed and dumps raw bytes to your terminal.

> **Tip — if your terminal is garbled**, type `reset` and press Enter to restore it.

---

## Part C — Identify the file type first

```bash
file sample.gff.gz
```

Output: `gzip compressed data`. Running `file` before opening an unknown file would have saved you from Part B.

> **Tip — `file` examines content, not the filename.** Even if someone renames `genome.gz` to `genome.fasta`, `file` still reports the truth.

---

## Part D — Read it properly with zcat

`zcat` decompresses on the fly and streams clean text — nothing written to disk:

```bash
zcat sample.gff.gz
```

All 20 lines, readable. For larger files always pipe to `head`:

```bash
zcat sample.gff.gz | head -5
```

---

## Part E — Compression ratio: same file, both forms

Now compress the full annotation and compare both versions:

```bash
gzip -k GCF_000005845.2_ASM584v2_genomic.gff
ls -lh GCF_000005845.2_ASM584v2_genomic.gff GCF_000005845.2_ASM584v2_genomic.gff.gz
```

Same data — the `.gz` is 3–5× smaller. Genomics files are highly repetitive and compress well. Always store and transfer them as `.gz`.

---

## Part F — Apply the same workflow to the genome sequence

Download the full *E. coli* K-12 genome in FASTA format (gzipped):

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

Check the type, then read safely:

```bash
file GCF_000005845.2_ASM584v2_genomic.fna.gz
zcat GCF_000005845.2_ASM584v2_genomic.fna.gz | head -3
```

The line starting with `>` is the FASTA sequence header — chromosome name, accession, and description.

---

Click **Check** to verify.
