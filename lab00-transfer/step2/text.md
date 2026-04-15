# Upload with scp

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

## Part B — Find the file to upload

A genome file has been left for you on this machine. Look for it:

```bash
ls /root/lab00_local/
```

You should see `genome.fasta`.

---

## Part C — Copy it to the server

Use `scp` to push the file to your `lab00` directory on `labserver`:

```bash
scp /root/lab00_local/genome.fasta student@labserver:lab00/
```

(password: `student`)

> **Tip — avoid `~/` on the destination side.**
> You might expect `student@labserver:~/lab00/` to work, but `~/` expansion on
> the remote side is not guaranteed in all `scp` versions and configurations.
> Use a **relative path** (`lab00/` — interpreted from the remote user's home)
> or an **absolute path** (`/home/student/lab00/`) instead.

---

## Part D — Confirm the upload

SSH back in and check that the file arrived:

```bash
ssh student@labserver
```

(password: `student`)

```bash
ls -lh ~/lab00/
```

You should see `genome.fasta` alongside the `ecoli/` directory from the previous step.

Click **Check** to verify.
