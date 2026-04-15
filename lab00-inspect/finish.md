# Well done

## What you practiced

| Command | Safe for binary? | Safe for huge files? | Notes |
|---------|-----------------|----------------------|-------|
| `file filename` | yes | yes | Always run this first |
| `wc -l filename` | no | yes | Count lines before opening |
| `head -N filename` | no | yes | Preview the top |
| `tail -N filename` | no | yes | Preview the bottom |
| `cat filename` | no | **no** | Only for small, known-text files |
| `zcat file.gz` | — | yes | Streams decompressed output; pipe to `head` |
| `gunzip file.gz` | — | yes | Writes decompressed copy to disk |
| `gzip -k filename` | — | yes | Compresses; `-k` keeps the original |

Two things to remember on a genomics server:
- **Never `cat` an unknown file** — run `file` first, then `wc -l` if it is text.
- **Genomics files live as `.gz`** — `zcat` reads them without spending disk space.

## Next

In the next lab you will run your first quality-control analysis on real sequencing reads.
