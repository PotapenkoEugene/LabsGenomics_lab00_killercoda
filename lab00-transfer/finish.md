# Well done

## What you practiced

| Command | Direction | Runs on |
|---------|-----------|---------|
| `wget <URL>` | internet → current host | wherever you are |
| `mv SOURCE DEST` | local rename / move | wherever you are |
| `scp user@host:remote/file ./` | remote → local | the **local** machine |
| `scp /local/file user@host:path` | local → remote | the **local** machine |

Two things to remember about `scp`:
- It always runs on **your machine**, not on the server.
- In remote paths (both source and destination), prefer a relative path (`lab00/ecoli/file`) or an absolute path (`/home/student/...`) over `~/` — shell expansion of `~` is not guaranteed in all scp versions.

## Next

In the next exercise you will look inside files: `cat`, `head`, `tail`, and `wc` — and find out why running `cat` on the wrong file can flood your terminal.
