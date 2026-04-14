# Who am I? Where am I?

Two commands that tell you where you stand on any machine:

| Command | What it prints |
|---------|----------------|
| `whoami` | your username |
| `pwd` | your current directory |

## Part A — on this machine

```bash
whoami
```

```bash
pwd
```

You are **root**, home directory is **/root**.

## Part B — SSH to a second machine

Connect to `node01` as user `student` (password: `student`):

```bash
ssh student@node01
```

> **Tip:** Nothing appears as you type the password — that's normal.
> On real servers, passwords are often replaced by SSH keys — but that's a separate topic.

## Part C — same commands, different machine

```bash
whoami
```

```bash
pwd
```

Notice: username is now **student**, home directory is **/home/student**, and the prompt shows **node01**.

## Part D — mark your visit and return

`touch` creates an empty file. `ls` lists files in the current directory.

Create a file on `node01`, confirm it exists, then return:

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
