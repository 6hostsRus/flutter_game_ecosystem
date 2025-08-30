# Quick Ops Guide

> 5‑minute guide to running this repo with GitHub Automations.

## Daily Dev Flow
- Open PR → auto labels, CI (analyze, format, test, coverage).
- Assigned to board automatically.

## Release Flow
1. `/release-candidate 0.1.0`
   - Creates milestone, draft release, and checklist issues.
2. `/screenshots ios` and `/screenshots android`
   - Generate store screenshots.
3. `/submit-ios`
   - Build & upload to TestFlight.
4. `/promote android internal`
   - Upload AAB to Play Console internal track.
5. `/promote android production 20%`
   - Gradual rollout to production.
6. `/store sync ios|android`
   - Sync listing metadata and screenshots.

## Hotfix Flow
- `/hotfix start 1.2.3`
- Patch commits + PR
- `/hotfix release 1.2.3`

## Remote Config
- `/rc push env:prod file:platform/rc.json`

## Project Commands
- `/epic "Runner MVP" children: #12 #34`
- `/project to Game Ecosystem Board/In progress`
