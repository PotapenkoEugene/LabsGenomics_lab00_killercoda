# Well done

## What you practiced

| Command | Direction | Runs on |
|---------|-----------|---------|
| `wget <URL>` | internet → current host | wherever you are |
| `mv SOURCE DEST` | local rename / move | wherever you are |
| `scp /local/file user@host:path` | local → remote | the **local** machine |
| `scp user@host:path /local/dir` | remote → local | the **local** machine |

Two things to remember about `scp`:
- It always runs on **your machine**, not on the server.
- On the destination side, prefer a relative path (`lab00/`) or an absolute path (`/home/student/lab00/`) over `~/` — shell expansion of `~` is not guaranteed in all scp versions.

## Next

In the next exercise you will look inside files: `cat`, `head`, `tail`, and `wc` — and find out why running `cat` on the wrong file can flood your terminal.
