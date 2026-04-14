# Who am I? Where am I?

Two commands that tell you where you stand on any machine:

| Command | What it prints |
|---------|----------------|
| `whoami` | your username |
| `pwd` | your current directory |

## Part A — on controlplane (your starting machine)

```bash
whoami
```

```bash
pwd
```

## Part B — connect to the server

SSH into `labserver` as user `student` (password: `student`):

```bash
ssh student@labserver
```

> **Tip:** Nothing appears as you type the password — that's normal.
> On real servers, passwords are often replaced by SSH keys — but that's a separate topic.

## Part C — same commands, on the server

```bash
whoami
```

```bash
pwd
```

Notice: username is now **student**, home directory is **/home/student**, and the prompt shows **labserver**.

## Part D — mark your visit and return

`touch` creates an empty file. `ls` lists files in the current directory.

Create a file on `labserver`, confirm it exists, then return to `controlplane`:

```bash
touch iwashere
ls
exit
```

Back on `controlplane`, do the same:

```bash
touch iwasheretoo
ls
```

Click **Check** to verify.
