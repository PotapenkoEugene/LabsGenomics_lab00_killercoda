# Download from the server with scp

`scp` copies files over SSH. Unlike `wget`, it transfers files **between two machines** — and it always runs on **your local machine**, not on the server.

To use it, you need to leave the server first.

---

## Part A — Exit the server

If you are still connected to `labserver`, exit back to your home machine:

```bash
exit
```

Your prompt should now show `root@controlplane`.

---

## Part B — Copy a file from the server

You downloaded `ecoli_genome.fna.gz` to the server in the previous step. Fetch it to your local machine with `scp`:

```bash
scp student@labserver:lab00/ecoli/ecoli_genome.fna.gz ./
```

(password: `student`)

Confirm the file arrived here on `controlplane`:

```bash
ls -lh ecoli_genome.fna.gz
```

> **Tip — avoid `~/` in remote paths.**
> You might expect `student@labserver:~/lab00/ecoli/ecoli_genome.fna.gz` to work,
> but `~/` expansion on the remote side is not guaranteed in all `scp` versions
> and configurations. Use a **relative path** (`lab00/ecoli/file` — interpreted
> from the remote user's home) or an **absolute path**
> (`/home/student/lab00/ecoli/file`) instead.

Click **Check** to verify.
