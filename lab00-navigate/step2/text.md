# ls Flags — Find a Needle in a Thousand Files

`ls` alone just prints names in alphabetical order. With the right flags it answers a real question: *which file is the biggest?*

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Navigate back to the data directory

You already know the path. Use Tab to get there:

```bash
cd /shared/lab00/samples_2024/raw_
```

Press `Tab`, then:

```bash
cd batch_
```

Press `Tab`. Confirm with `pwd`.

---

## Part B — Plain `ls` is useless here

```bash
ls
```

There are a thousand files. You cannot spot the biggest one by scrolling.

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

> **Tip:** `| head` shows only the first 10 lines of output — the biggest files appear at the top.

The **first file** listed is the largest. Note its name.

---

## Part D — Copy it to your home directory

`cp SOURCE DEST` copies a file. `~/` means your home directory.

```bash
cp the_giant_file_you_are_looking_for.dat ~/
```

> **Tip:** Tab-complete the filename — you already know how.

Verify the copy arrived:

```bash
ls -lh ~/
```

Click **Check** to verify.
