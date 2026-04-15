# Tab Completion — Save Your Fingers

Typing long paths by hand is slow and error-prone. **Tab completion** is the shell's built-in shortcut: start typing, press `Tab`, and the shell fills in the rest automatically.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — See what Tab does when there are multiple options

The shared data directory has several folders that start with the same prefix. Type the beginning and press `Tab`:

```bash
cd /shared/lab00/sam
```

Press `Tab` — the shell cannot complete the name yet because there are multiple matches. Press `Tab` **a second time** to see all the options.

You should see something like:

```
samples_2024/   samples_2025/   samples_archive/
```

Now you know which folder to go into. Continue typing to pick `samples_2024`:

```bash
cd /shared/lab00/samples_2024
```

---

## Part B — Tab through the rest of the path

Inside `samples_2024` there is one subdirectory. Type a few letters and press `Tab` — the shell should complete it with no ambiguity:

```bash
cd raw_
```

Press `Tab`. Then go one level deeper:

```bash
cd batch_
```

Press `Tab` again.

Confirm you arrived at the right place:

```bash
pwd
```

The path should end in `batch_01_results`.

---

## Part C — Mark your visit

```bash
touch iwashere
```

Click **Check** to verify.
