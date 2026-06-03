# Your Turn: Align Both Samples

> **Goal:** Map both trimmed samples to the SARS-CoV-2 reference. Do they align equally well?

---

## Part A — Build the index

```bash
bwa-mem2 index sars_cov2.fna
```

> **Tip:** The index files must be in the same directory as `sars_cov2.fna`.

---

## Part B — Align sample1

```bash
bwa-mem2 mem sars_cov2.fna sample1_clean.fastq.gz > sample1_clean.sam
```

---

## Part C — Align sample2

```bash
bwa-mem2 mem sars_cov2.fna sample2_clean.fastq.gz > sample2_clean.sam
```

---

## Part D — Compare mapping rates

```bash
samtools flagstat sample1_clean.sam
```

```bash
samtools flagstat sample2_clean.sam
```

Compare the "primary mapped (%)" lines.

Click **Check** to verify.
