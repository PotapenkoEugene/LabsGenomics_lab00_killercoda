# Read Compressed Files with zcat

## Part A — Create a small compressed file

You still have the annotation file from the previous step. Make a tiny sample from it:

```bash
cd ~/lab00/inspect
head -20 GCF_000005845.2_ASM584v2_genomic.gff > sample.gff
```

Compress it with `gzip -k` (`-k` keeps the original):

```bash
gzip -k sample.gff
ls -lh sample.gff sample.gff.gz
```

You now have both a plain-text version and a compressed version of the same 20 lines.

---

## Part B — What happens when you cat a .gz file?

Try it:

```bash
cat sample.gff.gz
```

Your terminal just filled with binary garbage. This is what gzip-compressed data looks like raw — the file is intact, but `cat` has no idea it is compressed and prints the bytes as-is.

> **Tip — if your terminal is garbled**, type `reset` and press Enter to restore it.

---

## Part C — Identify the file type first

```bash
file sample.gff.gz
```

Output: `gzip compressed data`. This is the check you should always run before opening an unknown file — `file` would have saved you from the garbled output above.

> **Tip — `file` examines content, not the filename.** Even if someone renames `genome.gz` to `genome.fasta`, `file` still reports the truth.

---

## Part D — Read it properly with zcat

`zcat` decompresses on the fly and streams clean text to the terminal — nothing is written to disk:

```bash
zcat sample.gff.gz
```

All 20 lines, readable. For larger files always pipe to `head` to avoid flooding:

```bash
zcat sample.gff.gz | head -5
```

---

## Part E — Download a real genome and apply the same workflow

Now try it on a real genomics file — the full *E. coli* K-12 genome sequence:

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

Check the type, then read safely:

```bash
file GCF_000005845.2_ASM584v2_genomic.fna.gz
zcat GCF_000005845.2_ASM584v2_genomic.fna.gz | head -3
```

The `>` line is the FASTA sequence header — chromosome name and accession. The lines below it are the DNA sequence.

---

## Part F — Compare sizes

```bash
ls -lh
```

The `.fna.gz` is around 1.4 MB. The uncompressed `.gff` from Step 1 is around 5 MB. Genomics files compress 3–10× — always store and transfer data as `.gz`.

---

## Part G — Mark your progress

```bash
touch ~/lab00/inspect/done_zcat.txt
```

Click **Check** to verify.
