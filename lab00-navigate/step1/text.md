# Tab Completion — Save Your Fingers

Typing full paths by hand is slow and error-prone. **Tab completion** is the shell's built-in shortcut: start typing, press `Tab`, and the shell fills in the rest.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Tab with a unique match

When only one option matches what you have typed, Tab completes it instantly.

The shared data directory has a folder with a long name. Type the first few letters and press `Tab`:

```bash
cd /shared/lab00/the_
```

The shell should complete the directory name immediately — you don't need to type the rest.

Confirm where you are:

```bash
pwd
```

---

## Part B — Tab when there are multiple options

Now things get interesting. Inside this directory there are several folders that all start with the same word.

Type the beginning and press `Tab`:

```bash
cd almost_
```

Nothing happens — the shell cannot decide for you. Press `Tab` **a second time** to list all matching options:

```
almost_exactly_here/   almost_here/   almost_there/
```

Now you know what is here. Type one more letter to pick `almost_exactly_here/` and press `Tab` again:

```bash
cd almost_e
```

The shell completes it unambiguously.

---

## Part C — One more level

Inside `almost_exactly_here/` there is one more directory. Use Tab to complete it:

```bash
cd and_
```

Press `Tab`.

Confirm your final location:

```bash
pwd
```

The path should end in `and_right_here`.

---

## Part D — Mark your visit

```bash
touch iwashere
```

Click **Check** to verify.
