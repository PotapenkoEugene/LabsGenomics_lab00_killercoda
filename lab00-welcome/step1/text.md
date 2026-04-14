# Who am I? Where am I?

Every time you land on a server — whether for the first time or the hundredth — run two commands first:

| Command | Meaning |
|---------|---------|
| `whoami` | Print your username |
| `pwd` | Print your current directory (Print Working Directory) |

## Part A — on this machine

Run the two commands and read the output:

```bash
whoami
```

```bash
pwd
```

Write down what you see. On this machine you are **root**, and you landed in **/root**.

## Part B — SSH to the second machine

Now connect to `node01` as the user `student`:

```bash
ssh student@node01
```

> **Note:** You will not be asked for a password — SSH keys are already set up for you. This is how production servers work: key-based auth instead of passwords.

## Part C — on node01

You are now on a different machine. Run the same two commands:

```bash
whoami
```

```bash
pwd
```

Compare the output to Part A. Notice:
- `whoami` now shows **student** (not root)
- `pwd` now shows **/home/student** (not /root)
- The shell prompt also changed — it includes the hostname **node01**

## Part D — leave a mark and return

Create a file to confirm you were here, then return to the first machine:

```bash
touch iwasthere
exit
```

You are back on `controlplane`. Click **Check** to verify the exercise.
