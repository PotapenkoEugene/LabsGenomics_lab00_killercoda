# Lab 08 Homework

Server's down — this VM replaces it. **No SSH needed**, you're already at the terminal. Do Part 1 (ENA, in your browser) first, exactly as the HW says, then come back here.

**Workspace:** `~/labs/lab08/HW` (created, and already your working directory).

**Tools:** `fastqc`, `fastp`, `seqkit`, `megahit` are active by default. `quast`, `busco`, `prokka` are separate environments — run `conda activate quast` / `conda activate busco` / `conda activate prokka` exactly as the HW instructs (`conda deactivate` when it says to). Part 7's `conda create -n abricate -c bioconda abricate` also works as written — run it live.

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
