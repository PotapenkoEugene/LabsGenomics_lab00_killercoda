# Lab 08 Homework

Server's down — this VM replaces it. **No SSH needed**, you're already at the terminal. Do Part 1 (ENA, in your browser) first, exactly as the HW says, then come back here.

**Tools:** all of them — `fastqc`, `fastp`, `seqkit`, `megahit`, `quast`, `busco`, `prokka`, `abricate` — are already installed and on your `PATH`. **Skip every `conda activate <name>` / `conda deactivate` line and Part 7's `conda create -n abricate ...` step** — just run the tool commands directly (e.g. `quast ...`, `busco ...`, `abricate --db card ...`).

> **Task B (`scp` to your laptop):** skip it. Use "When you're done" below to view the FastQC reports instead.

This is the full pipeline — `megahit`, `busco`, and `prokka` each take a few minutes, same as the HW's own timing notes.

---

## When you're done

Run this **once**:

```bash
~/view-reports.sh
```

Then open: [click here]({{TRAFFIC_HOST1_8080}}) and click any file in the list — the FastQC reports or `answers.txt` — to view or download it.

**Submit `answers.txt` to Moodle.**
