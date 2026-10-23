# Working with Aider on Aegis: setup and routine

Three files make up this system:

| File | For | Where it lives |
|---|---|---|
| CONVENTIONS.md | Aider (the AI reads it on every prompt) | Project root |
| AIDER_WORKFLOW.md (this file) | You: setup, the routine, your checks | docs\ |
| AIDER_PROMPTS.md | You: the prompts to paste, and the correction prompts | docs\ |

## Be honest about what this setup can do

- A 7B model knows ABL poorly. It will write code that looks right and is wrong. It will sometimes invent a statement or a field name. That is normal.
- So the rule is: small tasks, you read every line, you test, you undo when it is wrong. Aider writes first drafts. You are the reviewer.
- Ollama silently throws away anything that does not fit in its context window. A long chat makes the model forget the rules. Keep tasks small and start fresh often.
- On a laptop with a small graphics card, part of the model runs on the CPU. Slow answers are normal. Do not raise num_ctx above 8192.
- Some jobs are not for Aider. Bring these to Claude: ae_llm.p (the web call), any error you cannot fix in two tries, and a line-by-line review of the transaction in ae_seal.p.

## Part 1: One-time setup

Do these once, in order. Tick each one.

### 1. The project folder and Git

1. Open a terminal in the project root (the folder that holds src, seed, sim, schema and demo.bat).
2. Run `git status`.
   - If it says "not a git repository": run `git init`, then `git add .`, then `git commit -m "Aegis baseline"`.
3. Check .gitignore. It must contain at least:

```
db/
backup/
proof/
notes/
.env
*.lg
*.lk
*.bi
*.r
.aider*
```

4. Confirm the private notes (the ideas and venture notes) are not in this folder, or are listed above. This repo may become public.

### 2. The new tables and sequences

Aider will write code that uses these. Create them first.

1. Run this check once in the Procedure Editor. It tells you if any name clashes with an ABL keyword (a clash makes the dictionary refuse the name, or causes confusing errors later).

```
DEFINE VARIABLE cList AS CHARACTER NO-UNDO INITIAL 'ClauseID,Version,EngineScope,Regime,RuleText,LimitValue,Active,EffectiveFrom,RegimeID,DeclaredBy,Reason,DeclaredAt,WarrantID,ProposalID,Engine,Subject,Kind,BaseValue,ProposedValue,FloorValue,ProposalText,TextSource,CreatedAt,CharterVersion,Clauses,Ruling,ReasonCode,Authorizer,CustNum,SealedAt,PrevFingerprint,ExceptionID,ExcState,HandledBy,HandledAt,LogID,AiPoint,AiResult,Millis,LoggedAt'.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE cBad AS CHARACTER NO-UNDO.
DO i = 1 TO NUM-ENTRIES(cList):
    IF KEYWORD-ALL(ENTRY(i, cList)) <> ? THEN cBad = cBad + ENTRY(i, cList) + ' '.
END.
MESSAGE 'Names that are ABL keywords:' cBad VIEW-AS ALERT-BOX.
```

2. If any name is listed, tell Claude. The name is changed in CONVENTIONS.md and the blueprint before you create anything.
3. In the Data Dictionary, create the six tables from the blueprint's Data model section (ae_Charter, ae_Regime, ae_Proposal, ae_Warrant, ae_Exception, ae_AiLog) with exactly the field names in CONVENTIONS.md.
4. Create the five sequences: ae_ProposalSeq, ae_WarrantSeq, ae_ExceptionSeq, ae_RegimeSeq, ae_LogSeq.
5. Export a fresh full .df over schema\fairplay.df (keep the old one as a dated copy).
6. Prove the setup: build a database from the new .df in a scratch folder, as in the README steps. Then commit: `git add schema` and `git commit -m "Add Aegis tables"`.

### 3. Ollama

1. Run `ollama list`. Copy the exact model name shown (for example qwen2.5-coder:7b).
2. Set the address once: `setx OLLAMA_API_BASE http://127.0.0.1:11434`. Close the terminal and open a new one.
3. Test: `ollama run <the exact name>`, ask it one question, then type `/bye`.

### 4. Aider settings (two small files in the project root)

File 1: `.aider.model.settings.yml` (replace the name with the exact one from `ollama list`, keep the ollama_chat/ prefix):

```
- name: ollama_chat/qwen2.5-coder:7b
  extra_params:
    num_ctx: 8192
```

File 2: `.aider.conf.yml`:

```
model: ollama_chat/qwen2.5-coder:7b
read: CONVENTIONS.md
edit-format: whole
map-tokens: 0
```

Why: num_ctx stops Ollama using a tiny window. edit-format whole means the model writes the whole file, which a small model does more reliably than patches. map-tokens 0 turns off the repo map (it does not understand ABL and wastes context).

File 3: `.aiderignore` (stops Aider seeing files it must never edit):

```
db/
backup/
proof/
notes/
schema/
sim/
docs/
*.bat
```

### 5. First run

1. Put CONVENTIONS.md in the project root.
2. Run `aider`.
3. Check the banner: model is ollama_chat/..., edit format is whole, CONVENTIONS.md is read-only.
4. Type `/tokens`. The total must be well under 8000. CONVENTIONS.md should be about 2000.
5. Type `/exit`.

If any check fails, stop and fix it before you write code.

## Part 2: The routine for every session

### A. Before you start (about 3 minutes)

1. Decide today's one program. Open its prompt in AIDER_PROMPTS.md.
2. Close every OpenEdge window (editor, Proenv, Developer Studio). You will test later, and the database is single-user.
3. In the terminal, in the project root: `git status`. It must be clean. If not, commit the work or run `git restore .`
4. Make a branch for this task: `git switch -c ae-steward` (use the program's name).
5. Check Ollama is alive: `ollama list`.

### B. Start Aider and give it the files

1. Run `aider`.
2. Add the style reference as read-only: `/read-only src\fp_classify.p`
3. If you are editing a program that already exists, add it: `/add src\ae_steward.p`. For a new program, do not add anything. The prompt tells Aider to create it.
4. Never add more than three files. Fewer is better.

### C. Paste the prompt

1. Copy the whole prompt from AIDER_PROMPTS.md, including the `{` and `}` lines. Those lines let Aider accept many lines at once.
2. Paste it and press Enter.
3. Wait. When Aider stops, it has already committed. Do not trust it yet.

### D. Your checks (every program, every time)

Tick each one. Do not skip any.

1. **Only the right file changed.** In the terminal: `git show --stat HEAD`. It must list only the file you asked for. Anything else: `/undo`, then use the "touched other files" correction prompt.
2. **Read the whole file, top to bottom.** It is under 80 lines. Look for:
   - Every statement ends with a period. No semicolons.
   - Every DO, FOR and IF block has its END.
   - Every DEFINE VARIABLE has NO-UNDO.
   - Parameters come first, and match the contract in the prompt exactly: same count, same order, same type.
   - Only table, field and sequence names from CONVENTIONS.md. Compare each one.
   - No HTTP, JSON, file input or output, OS-COMMAND, SQL, classes or temp-tables.
   - No DELETE on ae_Warrant, ae_Proposal, ae_Exception or ae_AiLog.
   - Any word you do not recognise: look it up in the ABL reference. If you cannot find it, it is invented.
   - Any /* UNSURE */ comment: resolve it before moving on.
3. **Check syntax.** Open the file in the Procedure Editor and use its Check Syntax command (in the Compile menu). If you cannot find it, just run the program. Syntax errors show in a box before anything runs. Copy the exact message and line number.
4. **Run it with a normal case.** Use the "Check" lines under the prompt in AIDER_PROMPTS.md. Compare with the expected result written there.
5. **Break it once on purpose.** Give it a bad input (a zero, an empty text, a missing row). It must not crash, and it must give a sensible result.
6. **Run the suite.** `tests.bat`. The earlier tests must still PASS.
7. **Explain it back.** In Aider, type `/ask Explain this program line by line for a beginner.` If you cannot explain a line yourself afterwards, rewrite or remove it. A judge may ask you.
8. **Write one line in docs\journey.md:** the date, the program, what broke, what you fixed.

### E. Keep it or throw it away

**Keep (all checks passed):**

1. In Aider: `/exit`.
2. `git switch main`
3. `git merge ae-steward`
4. `git branch -d ae-steward`
5. `git push` (if you have a remote).

**Throw away (checks failed and two corrections did not help):**

1. In Aider: `/exit`.
2. `git switch main`
3. `git branch -D ae-steward`
4. Ask Claude, with the material listed in Part 4.

**Small undo inside a session:** `/undo` reverses Aider's last commit.

### F. End of the day

1. `git status` is clean and you are on main.
2. Copy the whole project folder as a dated backup.
3. The journey line is written and committed.

## Part 3: Aider commands you need

| Command | What it does |
|---|---|
| /add file | Puts a file in the chat so Aider may edit it |
| /read-only file | Shows a file to Aider but it cannot edit it |
| /drop file | Removes a file from the chat |
| /ls | Lists the files in the chat |
| /tokens | Shows how much of the context window is used |
| /clear | Forgets the chat history (keeps the files) |
| /reset | Forgets the history and drops all files |
| /ask question | Aider answers without editing anything |
| /undo | Reverses Aider's last commit |
| /diff | Shows the last change |
| /run command | Runs a terminal command from inside Aider |
| /exit | Leaves Aider |

## Part 4: When to stop and bring it to Claude

- Two correction prompts did not fix the same problem.
- Anything about the web call, secrets or JSON (ae_llm.p).
- The transaction in ae_seal.p, or the replay logic.
- Any error message you cannot read.
- Anything that changes a table or a sequence.
- Aider edited a file you did not ask for and /undo did not clean it.

Send Claude four things: the exact prompt you gave, the file as it is now, the exact error text, and what you expected.

## Part 5: When things go wrong

| Problem | Likely cause and fix |
|---|---|
| Aider cannot reach Ollama | Ollama is not running, or OLLAMA_API_BASE was set but the terminal was not reopened, or the model name is not exactly the one in `ollama list` |
| Very slow answers | Normal on a laptop. Close other programs, `/drop` extra files, keep num_ctx at 8192 or lower. The first answer after a pause is slowest because the model reloads |
| It forgets the rules or writes nonsense | The context is full. Run `/tokens`, then `/clear`, add fewer files, and ask again |
| It edits or creates other files | `/undo`, `/drop` everything, then repeat the task with: Only src\<file>.p |
| It answers in prose with no code | Say: Output the complete file only |
| It asks to add a file you did not mention | Answer n unless it is the one file for today |
| It keeps making the same mistake | Stop after two tries and use Part 4 |

## Part 6: Be open about it

- Aider with a local Qwen model wrote first drafts of some programs. You reviewed, tested and changed them.
- Say so in the README's "How this was built" section, next to the sentence about learning with Claude.
- Keep the claim as large as the proof: say "first drafts" for what Aider wrote, and "reviewed and tested" for what you did.
