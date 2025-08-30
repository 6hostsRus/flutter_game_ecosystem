name: Store Release Item
description: Item derived from the release train checklist
title: "[Store] "
labels: ["release-train","store"]
assignees: []
body:
  - type: markdown
    attributes:
      value: "Link: platform/checklists/release_train.md"
  - type: input
    id: section
    attributes:
      label: Checklist Section
      placeholder: e.g., 3) Assets Matrix
  - type: textarea
    id: details
    attributes:
      label: Details
      placeholder: Paste the specific [ ] item here
  - type: textarea
    id: dod
    attributes:
      label: Definition of Done
      value: |
        - [ ] Updated checklist item checked off
        - [ ] Linked PR merged
