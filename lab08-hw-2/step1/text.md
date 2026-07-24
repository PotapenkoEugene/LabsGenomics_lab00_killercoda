# Lab 08 Homework — Part 2: Annotate & Screen

Server's down — this VM replaces it. **No SSH needed**, you're already at the terminal.

Start here:

```bash
cd ~/labs/lab08/HW
```

Your assembly is already sitting at `assembly/final.contigs.fa` — use it as-is for this part.
Run every command below from this directory so your output (`quast_out/`, `busco_out/`,
`annotation/`, `resistance.tsv`, `answers_2.txt`) lands where the Check button looks for it.

**Tools:** `quast`, `busco`, `prokka`, `abricate` — already installed and on your `PATH`.
**Skip every `conda activate <name>` / `conda deactivate` line and Part 7's
`conda create -n abricate ...` step** — just run the tool commands directly (e.g. `quast ...`,
`busco ...`, `abricate --db card ...`).

> **BUSCO:** the `bacteria_odb10` lineage is already downloaded at
> `~/labs/lab08/HW/busco_downloads` — add `--offline --download_path ~/labs/lab08/HW/busco_downloads`
> to your `busco` command instead of letting it fetch the lineage live.

`busco` and `prokka` each take a few minutes, same as the HW's own timing notes.

Once you're through, record your Part 2 answers as `~/labs/lab08/HW/answers_2.txt`.

---

## When you're done

Run this **once**:

```bash
~/view-reports.sh
```

Then open: [click here]({{TRAFFIC_HOST1_8080}}) and click any file in the list — the reports
or `answers_2.txt` — to view or download it.

**Submit `answers_2.txt` to Moodle** — along with `answers_1.txt` from the **Part 1** scenario.
