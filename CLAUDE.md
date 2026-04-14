# Genomics Labs — Killercoda Scenarios

Interactive Killercoda exercises for the Tel-Hai College bachelor bioinformatics course (Lab 00).
Each scenario is a subdirectory in this repo and mirrors a matching section of the Lab 00 presentation.

## Active Obsidian Project

- Project: Genomics_Labs
- File: ~/Orthidian/projects/Genomics_Labs.md

## Source material

All content is ported from:

| Asset | Path |
|-------|------|
| Presentation | `~/Documents/Projects/Lectures/TelHai/Genomics/labs/lab00/presentation.md` |
| Plan | `~/Documents/Projects/Lectures/TelHai/Genomics/labs/lab00/plan.md` |
| Data files | `~/Documents/Projects/Lectures/TelHai/Genomics/labs/lab00/data/` |
| Images | `~/Documents/Projects/Lectures/TelHai/Genomics/labs/lab00/assets/` |

## Repo layout

```
lab00-welcome/          # scenario subdir (one per exercise)
├── index.json          # scenario metadata + step list
├── intro.md            # landing page before step 1
├── background.sh       # VM provisioning (runs at boot, invisible to student)
├── step1/
│   ├── text.md         # student-facing step instructions
│   └── verify.sh       # exit 0 = pass, non-zero = fail
└── finish.md           # wrap-up page
```

Each new exercise gets its own subdir. Register it manually on killercoda.com creator profile
after pushing to the default branch.

---

## Killercoda platform reference

### Backends (`imageid` in `index.json`)

| imageid | VMs | Use when |
|---------|-----|----------|
| `ubuntu` | 1 — Ubuntu 20.04, Docker+Podman | single-host exercises |
| `kubernetes-kubeadm-1node` | 1 — controlplane | k8s; fastest to boot |
| `kubernetes-kubeadm-2nodes` | 2 — controlplane + node01 | **any SSH-between-hosts exercise** |

For SSH exercises: use `kubernetes-kubeadm-2nodes`. The two VMs can reach each other as root
via pre-distributed keys (no password). Use `background.sh` to provision additional users.

### `index.json` skeleton

```json
{
  "title": "Human-readable title",
  "description": "One-line description shown on the scenario card",
  "details": {
    "intro":  { "text": "intro.md", "background": "background.sh" },
    "steps": [
      {
        "title": "Step 1 title",
        "text": "step1/text.md",
        "verify": "step1/verify.sh"
      }
    ],
    "finish": { "text": "finish.md" }
  },
  "backend": { "imageid": "kubernetes-kubeadm-2nodes" }
}
```

- Steps must be numbered sequentially (step1, step2, …, no skipping).
- `background` and `foreground` are optional per-step; `verify` is strongly recommended.

### Step markdown directives

Bash fenced blocks are **auto-executable** (click-to-run). Non-bash blocks are **auto-copyable**.
Override with HTML comments:

```markdown
<!-- INTERACTIVE exec START -->
```sql
SELECT * FROM table;
```
<!-- INTERACTIVE exec END -->

<!-- INTERACTIVE copy START -->
```bash
# copy-only, not exec
rm -rf /
```
<!-- INTERACTIVE copy END -->

<!-- INTERACTIVE ignore START -->
content stripped from Killercoda, kept in website build
<!-- INTERACTIVE ignore END -->
```

### Verify scripts

- `exit 0` = step passed (green check). Any non-zero = fail (red X).
- Executed on the primary VM (controlplane). Use `ssh node01 '…'` to check state on node01.
- Must be **fast** (<5 s) and **idempotent** — students click verify multiple times.

Example — check a file exists on node01:

```bash
#!/bin/bash
ssh -o StrictHostKeyChecking=no student@node01 'test -f /home/student/iwasthere'
```

### `background.sh` — VM provisioning

Runs at boot on the primary VM before the student's terminal appears. Use it for:
- `apt install` / package setup
- Creating users on either host
- Seeding data files

To run commands on node01 from a root-level `background.sh`:

```bash
ssh -o StrictHostKeyChecking=no node01 'useradd -m -s /bin/bash student'
scp /root/.ssh/authorized_keys node01:/tmp/root_authkeys
ssh node01 '
  mkdir -p /home/student/.ssh
  cp /tmp/root_authkeys /home/student/.ssh/authorized_keys
  chown -R student:student /home/student/.ssh
  chmod 700 /home/student/.ssh
  chmod 600 /home/student/.ssh/authorized_keys
'
```

This enables `ssh student@node01` from the student's root shell without a password.

### Images / assets

Place under `assets/` inside the scenario dir. Reference as `./assets/foo.png` in markdown.

---

## Story / naming convention

Every exercise simulates the same scenario: student is on their home computer connecting to a lab server.

| Killercoda host | Story name | Prompt shown | Role |
|----------------|------------|--------------|------|
| `controlplane` | `mypc` | `root@mypc` | student's home computer (primary terminal) |
| `node01` | `labserver` | `student@labserver` | the genomics server students SSH into |

Hostnames are set via `hostnamectl` in `background.sh`. `labserver` is added to `/etc/hosts`
on `mypc` so `ssh student@labserver` resolves correctly.

Every exercise should begin with the student running `ssh student@labserver` from `mypc`.
The actual work happens on `labserver`.

## Authoring conventions for this repo

- One scenario per subdir (`lab00-welcome/`, `lab00-navigate/`, …).
- Name steps as `step1/text.md`, `step1/verify.sh` (subdir pattern, not flat files).
- Every step must have a `verify.sh`. Use the marker-file pattern (`touch iwasthere`) for
  exercises that are hard to verify programmatically.
- `background.sh` goes at the **scenario root** (sibling of `index.json`), not in a step dir.
- Keep `background.sh` idempotent (`id student || useradd …` rather than bare `useradd`).
- Reuse images from source lab `assets/` — copy into `assets/` inside the scenario dir.
- Test JSON validity: `jq . index.json` before pushing.
