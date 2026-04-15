# Tab Completion — Save Your Fingers

Typing long paths is slow and error-prone. **Tab completion** is Linux's built-in shortcut: press `Tab` after a few letters and the shell fills in the rest.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Navigate with Tab

The server has a deeply nested directory. Start typing the path and press `Tab` at each level:

```bash
cd /shared/lab00/very_
```

> **Tip:** After `very_`, press `Tab` — the shell should complete the first directory name.
> Then type a few letters of the next level and press `Tab` again.
> Keep going until you reach the deepest level.

If Tab does nothing, you have not typed enough letters yet — add one more and try again.
If Tab beeps, press `Tab` **twice** to see all matching options.

Confirm you arrived with:

```bash
pwd
```

You should see a path ending in `.../one_more_level_promise`.

---

## Part B — Read a file by Tab-completing its name

There is a file here with a very long name. Start typing and let Tab do the work:

```bash
cat the_
```

Press `Tab` — the shell should complete the filename.

Read what it says. Remember the word.

---

## Part C — Mark that you were here

Go back to your home directory and create a file named after the secret word you just read:

```bash
cd ~
touch <the_word_you_read>
```

Click **Check** to verify.
