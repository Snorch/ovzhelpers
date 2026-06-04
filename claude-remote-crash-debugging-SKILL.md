---
name: remote-crash-debugging
description: Analyze a kernel crash dump (vmcore) on a remote host with the crash utility, using the user's helper script crash-remote to keep one persistent crash session alive across commands. Use when the user asks to debug, inspect, or analyze a vmcore/crashdump/panic on a remote machine — running crash commands like bt, ps, log, struct, dmesg. The session is reused across tool calls so crash is initialized only once (initialization is slow).
---

# Remote crash dump analysis via persistent crash session

The user's `crash-remote` script keeps a single `crash` session running on a remote host and feeds it commands over a persistent SSH connection (ControlMaster) plus a FIFO. Always use it instead of raw `ssh ... crash`: re-launching `crash` per command re-reads the vmcore and is very slow, whereas this reuses one warm session.

## Workflow
1. `crash-remote start <host> <vmlinux> <vmcore>` — run once at the start of the analysis. Blocks until crash is initialized (can take minutes) and prints the banner.
2. `crash-remote cmd <command>` — run as many crash commands as needed; each returns just that command's output.
3. `crash-remote stop` — clean up the session and close the SSH connection when done.

```bash
~/bin/crash-remote start root@server /usr/lib/debug/vmlinux /var/crash/vmcore
~/bin/crash-remote cmd bt
~/bin/crash-remote cmd "ps | grep UN"
~/bin/crash-remote cmd "struct task_struct.comm,pid ffff8800deadbeef"
~/bin/crash-remote stop
```

## Rules
- Always quote a `cmd` argument that contains spaces, pipes, or shell metacharacters: `crash-remote cmd "ps | grep UN"`.
- Start the session once, then reuse it for every command — do not `start` again unless `status` shows it is gone.
- There is one global session at a time (state in `/tmp/crash-remote.env`). Starting a new one replaces any previous session.
- Run `crash-remote status` if unsure whether a session is active; `crash-remote log [N]` shows the last N lines of raw crash output.
- Always run `crash-remote stop` before finishing the conversation to free the remote crash process and SSH master.
