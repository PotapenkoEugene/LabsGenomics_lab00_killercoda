# Lab 08 Homework — Part 1: Assemble

Server's down — this VM replaces it. **No SSH needed**, you're already at the terminal. Do the
HW's Part 1 (ENA, in your browser) first, exactly as the HW says, then come back here for
Parts 2–5 (QC, trim, assemble).

**Tools:** `fastqc`, `fastp`, `seqkit`, `megahit` — already installed and on your `PATH`. **Skip
every `conda activate <name>` / `conda deactivate` line** — just run the tool commands directly.

> **Task B (`scp` to your laptop):** skip it. Use "When you're done" below to view the FastQC
> reports instead.

`megahit` takes a few minutes, same as the HW's own timing notes.

Once you're through assembly, record your Part 1 answers as `~/labs/lab08/HW/answers_1.txt`.

---

## When you're done

Run this **once**:

```bash
~/view-reports.sh
```

Then open: [click here]({{TRAFFIC_HOST1_8080}}) and click any file in the list — the FastQC
reports or `answers_1.txt` — to view or download it.

**Submit `answers_1.txt` to Moodle.** You'll also need `answers_2.txt` from the **Part 2**
scenario (annotation + resistance screening) — submit both.
