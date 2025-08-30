name: Task
description: General development task
title: "[Task] "
labels: ["task"]
assignees: []
body:
  - type: textarea
    id: summary
    attributes:
      label: Summary
      description: What needs to be done?
      placeholder: Short description
  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance Criteria
      description: Define when this is done.
      placeholder: Given/When/Then...
  - type: textarea
    id: checklist
    attributes:
      label: Subtasks
      value: |
        - [ ]
