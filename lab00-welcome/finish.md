# Well done

You have confirmed two things that every bioinformatician knows by instinct:

- `whoami` tells you **who** you are on the current machine
- `pwd` tells you **where** you are on the current machine
- `ssh user@host` moves you to a **different machine with a different identity**

These details matter. A wrong server or a wrong user is one of the most common causes of "the file isn't there" errors in genomics workflows.

## What you practiced

| Command | Purpose |
|---------|---------|
| `whoami` | Print your username |
| `pwd` | Print your current directory |
| `ssh student@node01` | Open a remote shell on another machine |
| `touch iwasthere` | Create an empty file (mark your presence) |
| `exit` | Close the remote shell and return to the previous machine |

## Next

In the next exercise you will navigate the filesystem: `ls`, `cd`, `mkdir` — and learn why `cat` is dangerous on a 50,000-line file.
