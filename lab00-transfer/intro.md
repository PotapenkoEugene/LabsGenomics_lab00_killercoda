# Transferring Files

You are on `controlplane` — your home computer.

`labserver` is the remote genomics server. It has the RAM and disk to process sequencing data, but no web browser and no connection to your local files.

Getting data where it needs to be is a core skill. There are two directions:

| Direction | Tool | Notes |
|-----------|------|-------|
| Internet → server | `wget` | Run on the server; pulls from any URL |
| Laptop → server | `scp` | Run on the laptop; pushes a local file over SSH |

In this exercise you will practice both.
