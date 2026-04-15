# Navigate and Complete with Tab

Before we work with data, learn to move around the server efficiently.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Basic navigation

Go to the shared data directory:

```bash
cd /shared
```

List what's here:

```bash
ls
```

You should see `lab00/` — the class data directory. Move into it:

```bash
cd lab00
```

Confirm your location:

```bash
pwd
```

You are now in `/shared/lab00` — where all class data lives.

---

## Part B — Tab with a unique match

Typing long paths by hand is tedious and error-prone. **Tab completion** lets the shell fill in the rest automatically.

There is a folder here with a long name. Type the first few letters and press `Tab`:

```bash
cd the_
```

> Press `Tab` after typing `the_` — the shell completes it instantly because only one folder starts with those letters.

Confirm where you are:

```bash
pwd
```

---

## Part C — Tab when there are multiple options

Inside this folder there are three directories that all start with the same word.

Type the beginning and press `Tab`:

```bash
cd almost_
```

Nothing happens — the shell cannot choose for you. Press `Tab` **a second time** to list all matching options:

```
almost_exactly_here/   almost_here/   almost_there/
```

Now add one more letter to pick `almost_exactly_here/` and press `Tab`:

```bash
cd almost_e
```

The shell completes it unambiguously.

---

## Part D — One more level

Inside `almost_exactly_here/` there is one more directory. Complete it with Tab:

```bash
cd and_
```

Press `Tab`. Confirm you arrived:

```bash
pwd
```

The path should end in `and_right_here`.

---

## Part E — Mark your visit

```bash
touch iwashere
```

Click **Check** to verify.
