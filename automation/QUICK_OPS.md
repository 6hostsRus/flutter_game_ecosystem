# Quick-Ops: Ship Games Fast

This repo includes GitHub Actions, slash-commands, and scripts to run your **release train** with minimal clicks.

## 1) One-time Setup (10 min)
1. Add repo **Secrets** (Settings → Secrets → Actions), see `automation/secrets.example.md`.
2. Create a Project (Beta) and copy its URL into secret `PROJECT_URL`.
3. `gh auth login` on your machine if you will run local scripts.

## 2) Daily PR Flow
- Open PR → CI runs (format, analyze, tests, coverage).
- Auto-label + add to project board.
- Golden diffs checked (if goldens present).

## 3) Release Flow (5 commands)
1. In the release tracking issue, comment:  
   **`/release-candidate 0.1.0`**  
   → creates milestone, draft release, and spawns store tasks.
2. **`/screenshots ios`** and **`/screenshots android`**  
   → builds & saves screenshot artifacts.
3. **`/submit-ios`** and **`/promote android internal`**  
   → uploads TestFlight build / uploads Android AAB to internal track.
4. Address review feedback.
5. **`/promote android production 20%`** then **`/promote android production 100%`**  
   and **`/store sync ios`** / **`/store sync android`** to push listing text/images.

## 4) Hotfix Flow
- **`/hotfix start 1.2.3`** → creates branch & PR.
- Merge fix PR.
- **`/hotfix release 1.2.3`** → tags & prepares store sync.

## 5) Useful Extras
- **`/epic "Runner MVP" children: #12 #34 #56`** → builds parent/child links.
- **`/project to Game Ecosystem Board/In progress`** → drops the current issue/PR on the board column.

See workflow sources in `.github/workflows/` for exact behavior.


---
**See also:** `ai_instructions.md` for the AI behavior contract.
