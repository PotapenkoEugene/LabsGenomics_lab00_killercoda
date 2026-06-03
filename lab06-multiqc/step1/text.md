# Your Turn: Aggregate with MultiQC

> **Goal:** Build one unified QC report covering FastQC, fastp, and samtools for both samples.

> **Note:** MultiQC is available in your environment — skip directly to Part B.

---

## Part B — Generate samtools stats for both SAMs

```bash
samtools stats sample1_clean.sam > sample1_clean.stats.txt
```

```bash
samtools stats sample2_clean.sam > sample2_clean.stats.txt
```

---

## Part C — Run MultiQC

```bash
multiqc ~/labs/lab06/
```

> **Tip:** multiqc auto-discovers FastQC zips, fastp JSON, and samtools stats files in the given path.

---

## View the report

```bash
~/view-reports.sh
```

Open: [click here]({{TRAFFIC_HOST1_8080}})

Click **Check** to verify.
