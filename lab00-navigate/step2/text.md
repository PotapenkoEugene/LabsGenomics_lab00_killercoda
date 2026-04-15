# ls Flags — Find a Needle in Hundreds of Files

`ls` alone just prints names. With the right flags it answers real questions: *which file is biggest? which was touched most recently?*

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Navigate back to the deep directory

You know the path — use Tab to get there quickly:

```bash
cd /shared/lab00/very_
```

Press `Tab` through each level.

---

## Part B — Plain `ls` is hopeless here

```bash
ls
```

There are hundreds of files. You cannot spot the biggest one by eye.

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

> **Tip:** `| head` shows only the top 10 lines — the biggest files come first.

The **first file** in the output is the largest. Note its name.

---

## Part D — Sort by time: `ls -lt`

```bash
ls -lt | head
```

The **first file** is the most recently modified. Note its name.

---

## Part E — Copy both files to your home directory

`cp SOURCE DEST` copies a file. `~/` is your home directory.

```bash
cp the_giant_file_you_are_looking_for.dat ~/
cp freshly_baked_this_morning.log ~/
```

> **Tip:** Tab-complete the filenames — you already know how.

Verify the copies arrived:

```bash
ls -lh ~/ | head
```

Click **Check** to verify.
