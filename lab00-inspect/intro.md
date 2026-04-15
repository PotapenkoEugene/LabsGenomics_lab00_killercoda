# Looking Inside Files

You have a file on the server. Now what?

Opening it blindly with `cat` sounds natural — but on a genomics server, files are often large enough to flood your terminal with hundreds of thousands of lines, or they are binary (gzipped) and will garble your display.

This exercise teaches you to look before you leap.

| Command | What it does | When to use it |
|---------|--------------|----------------|
| `file` | Identifies file type from content | Always — before opening an unknown file |
| `wc -l` | Counts lines | Before `cat` — know how big it is |
| `head -N` | First N lines | Safe preview of any text file |
| `tail -N` | Last N lines | Check file end or truncation |
| `cat` | Prints the whole file | Only on small, known-text files |
| `zcat` | Prints a gzipped file without unpacking | Any `.gz` file |

> **Rule of thumb:** always run `file` on an unfamiliar file before anything else.
