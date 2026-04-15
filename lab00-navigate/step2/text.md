# ls Flags — Find the Biggest File

`ls` alone just prints names in alphabetical order — it tells you nothing about size. The right flags turn it into a powerful tool.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Navigate back to the data directory

You know the path. Use Tab at every level:

```bash
cd /shared/lab00/the_
```

Tab → then:

```bash
cd almost_e
```

Tab → then:

```bash
cd and_
```

Tab. Confirm with `pwd`.

---

## Part B — Plain `ls` is useless here

```bash
ls
```

A thousand files, all named alike. You cannot tell which is biggest by looking.

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

> **Tip:** `| head` shows only the first 10 lines — the biggest file is at the top.

The **first file** in the output is the largest. Note its full name.

---

## Part D — Copy it to your home directory

`cp SOURCE DEST` copies a file. `~/` is your home directory.

```bash
cp amithebiggest_XXXX.dat ~/
```

Replace `amithebiggest_XXXX.dat` with the actual name you found in the previous step.

> **Tip:** Tab-complete the filename — type `ami` and press Tab.

Verify it arrived:

```bash
ls -lh ~/
```

Click **Check** to verify.
