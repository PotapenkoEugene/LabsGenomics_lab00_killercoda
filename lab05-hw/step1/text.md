# Lab 05 Homework

Server's down — this VM replaces it. **No SSH needed**, you're already at the terminal.

**Workspace:** `~/labs/lab05/HW` (created, and already your working directory). The 4 source samples are staged at `/home/evgenip/labs/lab05/HW/` — the HW's `cp` command works as written.

**Line 1 of `answers.txt`:** put your **real Tel-Hai ID**, not `student` — everyone on this VM logs in as `student`.

Open the **Lab 05 homework PDF (Moodle)** and work through Tasks A–E here in the terminal, exactly as written.

> **Task D (`scp` to your laptop):** skip it. Instead, when you reach FastQC reports, jump to "When you're done" below — the link there both shows and downloads the `.html` files.

---

## When you're done

Serve the workspace and grab your files:

```bash
~/view-reports.sh
```

Open: [click here]({{TRAFFIC_HOST1_8080}}) — view each `*_fastqc.html` (Per base sequence quality verdict) and download `answers.txt` (right-click → **Save Link As**).

**Submit `answers.txt` to Moodle.** Grading is no longer done on the server.

Click **Check** once `answers.txt` (≥5 lines), the 4 `sample*.fastq.gz`, and the 4 `*_fastqc.html` exist.
