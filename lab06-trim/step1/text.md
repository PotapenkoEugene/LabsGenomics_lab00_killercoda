# Your Turn: Clean Both Samples

> **Goal:** Trim both samples with fastp, then run FastQC to compare raw and clean.

---

## Part A — Enter your workspace

```bash
cd ~/labs/lab06/
```

---

## Part B — Copy sample files

```bash
cp /home/evgenip/labs/lab06/sample*.fastq.gz ~/labs/lab06/
```

> **Tip:** `*` means "any characters" — it matches whatever is there. `sample*.fastq.gz` matches `sample1.fastq.gz`, `sample2.fastq.gz`, `sampleABC.fastq.gz` — anything that starts with `sample` and ends with `.fastq.gz`.

---

## Part C — Run fastp on sample1

```bash
fastp -i sample1.fastq.gz -o sample1_clean.fastq.gz
```

---

## Part D — Run fastp on sample2

```bash
fastp -i sample2.fastq.gz -o sample2_clean.fastq.gz
```

---

## Part E — Run FastQC on all clean files

```bash
fastqc sample*_clean.fastq.gz
```

---

## Part F — Download reports to your laptop

Run this in your **laptop's terminal** (not here):

```
# run on your own laptop, not here
# On-campus:
scp username@77.137.28.104:~/labs/lab06/*_fastqc.html ~/Downloads/
# Off-campus: connect to university VPN first, then use 192.168.133.200
```

Mac — open **Terminal** · Windows — open **PowerShell** (`~/Downloads/` works in both)

---

## View reports here

You can also open the HTML reports directly in your browser:

```bash
~/view-reports.sh
```

Then open: [click here]({{TRAFFIC_HOST1_8080}})

Click **Check** to verify.
