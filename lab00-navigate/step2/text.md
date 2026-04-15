# Sort, Make Room, Copy

`ls` alone prints names in alphabetical order — it tells you nothing about size or age. The right flags let you ask specific questions.

You are already in the data directory from the previous step.

---

## Part A — Plain `ls`

```bash
ls
```

A hundred files, all named the same way. You cannot tell which is biggest or newest by looking.

---

## Part B — Sort by size: `ls -lhS`

| Flag | Meaning |
|------|---------|
| `-l` | long format — shows size, date, permissions |
| `-h` | human-readable sizes (`5.0M` instead of `5242880`) |
| `-S` | sort by size, largest first |

```bash
ls -lhS
```

The **first file** in the output is the largest. Note its full name — you will need it in Part E.

---

## Part C — Sort by time: `ls -lt`

| Flag | Meaning |
|------|---------|
| `-l` | long format |
| `-t` | sort by modification time, newest first |

```bash
ls -lt
```

The top of the list will be `iwashere` — the file **you** created in the previous step. Your own files always appear newest. Scroll past it to find the newest file that was already on the server before you arrived: `freshly_arrived.dat`.

---

## Part D — Build your own workspace

`~/` is your home directory. `mkdir` creates a new directory.

```bash
mkdir ~/lab00
```

---

## Part E — Copy both files into your workspace

`cp SOURCE DEST` copies a file.

Copy the biggest file you found in Part B:

```bash
cp amithebiggest_XXX.dat ~/lab00/
```

Replace `XXX` with the number from Part B. Tip: type `cp ami` and press Tab.

Copy the newest file from Part C:

```bash
cp freshly_arrived.dat ~/lab00/
```

Verify both arrived:

```bash
ls -lh ~/lab00/
```

Click **Check** to verify.
