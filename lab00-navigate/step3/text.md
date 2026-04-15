# mkdir — Build Your Own Workspace

On a shared server everyone has their own home directory (`/home/student`). Inside it you can create whatever structure you like. `mkdir -p` lets you build a whole tree in one command.

Connect to the server:

```bash
ssh student@labserver
```

(password: `student`)

---

## Part A — Create a nested directory in one command

`mkdir -p` creates all parent directories along the path — no need to create them one by one.

```bash
mkdir -p ~/lab00/projects/ecoli
```

This creates three directories at once: `lab00/`, `lab00/projects/`, and `lab00/projects/ecoli/`.

---

## Part B — Navigate in and confirm your location

```bash
cd ~/lab00/projects/ecoli
pwd
```

`pwd` should print `/home/student/lab00/projects/ecoli`.

---

## Part C — Mark the workspace as ready

```bash
touch ready
```

Then check that the file is there:

```bash
ls -lh
```

Click **Check** to verify.
