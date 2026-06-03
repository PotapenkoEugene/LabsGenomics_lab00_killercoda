# Your Turn: Aggregate with MultiQC

> **Goal:** Build one unified QC report covering FastQC, fastp, and samtools for both samples.

> **Note:** MultiQC is available in your environment — skip to Part B.

---

## Part B — Generate samtools stats for both SAMs

```bash
cd ~/labs/lab06/
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

## Part D — Download the report to your laptop

Run this in your **laptop's terminal** (not here):

```
# run on your own laptop, not here
scp username@77.137.28.104:~/labs/lab06/multiqc_report.html ~/Downloads/
```

---

## View the report here

You can also open the MultiQC report directly in your browser:

```bash
~/view-reports.sh
```

Then open: [click here]({{TRAFFIC_HOST1_8080}})

Click **Check** to verify.
