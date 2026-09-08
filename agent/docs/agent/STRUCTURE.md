# structure — the code limits, and what they are actually for

## Why there is a limit at all

Zamstars apps get handed to developers. The thing developers refuse to inherit is not a big
codebase, it is a file nobody can hold in their head — the 900-line `App.tsx` where every
feature touches every other one. That file is also the file an agent cannot edit surgically:
asked to change one thing it rewrites the whole file, and the diff is unreviewable, so nobody
reviews it, so the next agent inherits whatever the last one guessed.

The limits exist to keep two things true: **a human who did not write the file can read it in
one sitting**, and **an agent can change part of it without rewriting all of it.**

## The numbers

| Limit | Threshold | What happens |
|---|---|---|
| Source file | **200 lines** | Say so, propose the split. Proceed only if the user declines — and record the decline as a DECISIONS entry. |
| Source file | **300 lines** | Hard fail. Split before committing, not as a follow-up. |
| Function | **50 lines** | Same as 200: propose, don't force. |
| Exports per file | **1** | Named the same as the file. `types/` is exempt (below). |

200 is about three screens — roughly what a reviewer holds in working memory before they start
scrolling back. 300 is where "I'll read it later" becomes "I'll trust it." Neither number is
sacred; they are the point where a conversation should happen, not a law of nature.

## The limit is a proxy, and it is gameable

Line count measures size, not the thing that actually matters. **Two 130-line files that must
always be edited together are worse than one 260-line file** — you have paid the cost of a split
and bought nothing, and now the reader has to hold two files instead of one.

The rule the count is standing in for: **a file has one reason to change.** When the count trips,
that is the question to ask. If the honest answer is "this file has one job and the job is big",
say so and record it. Gaming the number to make the check pass is worse than failing the check.

## How to split — in this order

1. **Pull pure logic down to `lib/`.** The part that takes data and returns data, with no React
   in it. This is the split that pays every time: it is testable, reusable, and it shrinks the
   component by more than you expect.
2. **Pull out a sub-view.** A block of JSX with its own props and no shared local state. If it
   needs three pieces of the parent's state passed down, it is not a seam — leave it.
3. **Pull state into a hook.** `useThing.ts` beside the feature. Good when the file is long
   because of effects and handlers, not markup.
4. **Split the file by job.** If it is doing two things — a list and an editor — those were
   always two files.

Never split top-half / bottom-half to get under a number. Never create `utils.ts`, `helpers.ts`
or `misc.ts`; a file named for where things go instead of what they do becomes the next dumping
ground.

**Signs you split badly:** the new file exports six things the old one imports; the two files
appear together in every commit from now on; the new file is named `<Original>Helpers`.

## Exempt from the line count

- **Generated files** — `*.gen.ts`, generated Supabase types, lockfiles. Regenerate, don't edit.
- **`src/types/`** — type declarations with no behavior. Multiple exports allowed here.
- **SQL migrations** — append-only and never edited after they run; splitting one breaks ordering.
- **Data literals** — a long constant array is a table, not logic. It still gets its own file.
- **Test fixtures.**

That is the whole list. A sixth exemption is a DECISIONS entry, not a judgment call in the moment.

## How it is checked

From the repo root, at every handoff and in every groom:

```
find . -path ./node_modules -prune -o -path ./dist -prune -o -path ./.git -prune -o \
  -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.css' \) \
  -print0 | xargs -0 wc -l | sort -rn | head -20
```

Read the top of that list against the exemption list before reporting anything.

**Known weakness:** there is no cheap portable command for the 50-line function rule, so it is
checked by eye on the longest files from the list above. It is therefore the limit most likely
to rot. If a file is under 200 lines and still unreadable, one giant function is usually why.

## Import direction

`pages → features → lib → types`. Downward only.

- Never sideways between two `features/*`. Two features needing the same thing means the thing
  belongs **below** both of them — move it to `lib/` or `components/`.
- Never upward. A `lib/` file that imports from `features/` has stopped being a library.
- `features/` is the default home for new code. `components/` is only for what two or more
  features already use — not what you think they might.

Sideways imports are what turn a structured repo back into the single-file app, one shortcut at
a time, and they are invisible in a line count. They are worth more attention than the numbers.

## When someone declines a split

Record it as a DECISIONS entry with the real reason. That entry is what stops the same argument
happening again in three weeks. **Declining twice on the same file means the limit is wrong for
this repo** — change the number once, in the app-specific rules in `AGENTS.md`, with a decision
explaining why. Do not leave a rule in place that the team routinely ignores; a rule everyone
overrides teaches that all the rules are optional.
