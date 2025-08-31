# Repo Refactor Bundle — RUNME

This bundle prepares your repo for the architecture in the PDF. It is idempotent: you can run it multiple times safely.

## What it does
1) Creates the proposed directory structure.
2) Moves existing files into their new locations (based on config/move_map.json).
3) Creates stub files for missing key modules and writes AI-copilot prompts next to them.
4) Writes a dry-run log so you can inspect changes before committing.

## Recommended Branch
Create and switch to a new branch (suggestion):

```bash
git checkout -b refactor/arch-alignment-main-YYYYMMDD
```
Replace YYYYMMDD with today's date.

## Dry Run (recommended)
```bash
bash scripts/bash/00_detect_repo_state.sh
bash scripts/bash/01_create_structure.sh --dry-run
bash scripts/bash/02_move_logic.sh --dry-run
bash scripts/bash/03_stub_missing.sh --dry-run
```

## Execute
```bash
bash scripts/bash/01_create_structure.sh
bash scripts/bash/02_move_logic.sh
bash scripts/bash/03_stub_missing.sh
```

Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File scripts/powershell/01_create_structure.ps1
powershell -ExecutionPolicy Bypass -File scripts/powershell/02_move_logic.ps1
powershell -ExecutionPolicy Bypass -File scripts/powershell/03_stub_missing.ps1
```

## Undo (best-effort)
```bash
bash scripts/bash/99_undo.sh
```

## Configure Moves
Edit config/move_map.json. Only existing sources will be moved; non-existent paths are skipped and logged.

## Stubs & Copilot
- Stubs are created only for critical files if they do not exist.
- See stubs/AI_COPILOT_STUBS.md for prompts to generate contents.