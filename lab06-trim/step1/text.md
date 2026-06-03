# Your Turn: Clean Both Samples

> **Goal:** Trim both samples with fastp, then run FastQC to compare raw and clean.

---

## Part A — Run fastp on sample1

```bash
fastp -i sample1.fastq.gz -o sample1_clean.fastq.gz
```

---

## Part B — Run fastp on sample2

```bash
fastp -i sample2.fastq.gz -o sample2_clean.fastq.gz
```

---

## Part C — Run FastQC on all clean files

```bash
fastqc sample*_clean.fastq.gz
```

> **Tip:** `*` means "any characters" — `sample*_clean.fastq.gz` matches both clean files.

---

## View reports

```bash
~/view-reports.sh
```

Open: [click here]({{TRAFFIC_HOST1_8080}})

Click **Check** to verify.
