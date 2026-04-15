# Sort, Make Room, Copy

`ls` alone just prints names. The right flags let you ask specific questions — like *which file is the biggest?*

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Navigate to the data directory

You know the path. Use Tab at every level:

```bash
cd /shared/lab00/the_
```

Press `Tab`.

```bash
cd almost_e
```

Press `Tab`.

```bash
cd and_
```

Press `Tab`. Confirm with `pwd`.

---

## Part B — Plain `ls` is useless here

```bash
ls
```

A thousand files, all named the same way. You cannot tell which is biggest by looking.

---

## Part C — Sort by size: `ls -lhS`

| Flag | Meaning |
|------|---------|
| `-l` | long format — shows size, date, permissions |
| `-h` | human-readable sizes (`5.0M` instead of `5242880`) |
| `-S` | sort by size, largest first |

```bash
ls -lhS | head
```

> **Tip:** `| head` shows only the first 10 lines. The biggest file appears at the top.

The **first file** in the output is the largest. Note its full name — you will need it in Part E.

---

## Part D — Build your own workspace

`~/` means your home directory. `mkdir -p` creates a directory tree in one command, even if parent directories do not exist yet.

```bash
mkdir -p ~/lab00
```

This creates `/home/student/lab00/` — your personal space on the server.

---

## Part E — Copy the giant file into your workspace

`cp SOURCE DEST` copies a file.

```bash
cp amithebiggest_XXXX.dat ~/lab00/
```

Replace `XXXX` with the number you found in Part C.

> **Tip:** Type `cp ami` and press `Tab` — the shell completes the filename.

Verify the file arrived:

```bash
ls -lh ~/lab00/
```

Click **Check** to verify.
