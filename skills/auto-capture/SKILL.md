---
name: auto-capture
description: >
  Auto-save mode: every answer you give is appended to a dated Markdown log
  (claude-answers/YYYY-MM-DD.md) and copied to the clipboard, so the user never
  has to copy-paste or screenshot replies. Use for /auto-capture, "답변 자동 저장",
  "답변 자동 복사", "캡처 모드", "save every answer", "copy your replies
  automatically". Stays on until "stop auto-capture" or "자동 저장 꺼".
---

# auto-capture

The user works in Claude Code (often inside VS Code) and wants every reply kept
somewhere without copying or screenshotting it themselves. While this mode is
on, save each reply as you give it.

## How to save a reply

Write your reply first in your head, then — before you show it in chat — pass
the exact same text to the bundled script, which appends it to today's log and
copies it to the clipboard:

```bash
bash "<this skill's base directory>/scripts/save_answer.sh" "<the user's request, in a few words>" <<'CLAUDE_ANSWER_END'
<your full reply, in Markdown, exactly as you will show it>
CLAUDE_ANSWER_END
```

- Keep the quoted delimiter `'CLAUDE_ANSWER_END'` so `$`, backticks and quotes
  in the reply are saved literally instead of being run by the shell.
- Then show the same reply in chat. The saved copy and the chat copy should
  match, because the log is only useful if the user can trust it.
- Make the save the last tool call of the turn, after any other work is done,
  so the log holds the final answer rather than a progress note.
- Save every reply while the mode is on, including short ones; the user asked
  for "all of them", and gaps make the log hard to trust.
- Don't comment on the save in chat beyond, at most, one short line such as
  `저장됨: claude-answers/2026-10-27.md`.

The log lives in `claude-answers/` under the current working directory, so
it opens right in the VS Code Explorer. If the user wants it elsewhere, set
`CLAUDE_ANSWERS_DIR=<folder>` in front of the command.

## Turning it on and off

- On the first turn, confirm in one line: where answers go (file + clipboard)
  and how to stop. Then save that confirmation too.
- Stays on for the rest of the session until the user says "stop auto-capture",
  "자동 저장 꺼", or similar. Confirm in one line that it is off, and stop
  saving from then on.

## If saving fails

If the script errors (for example, no clipboard tool), still give the reply in
chat and tell the user in one line what failed. The file save works even when
clipboard copy does not.
