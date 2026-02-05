#!/usr/bin/env bash
# Create GitHub labels for eth-homework repository
# Run this after pushing to GitHub: bash .github/scripts/create-labels.sh
#
# Label color taxonomy per CONTEXT.md:
# - Week labels: Blue family (파란 계열) for structural categorization
# - Type labels: Green family (초록 계열) for content type
# - Status labels: Yellow (needs-review), Blue (in-review), Green (approved)

set -euo pipefail

echo "Creating GitHub labels for eth-homework..."

# Week labels - blue family (파란 계열)
# Gradient from dark to light blue for visual week progression
gh label create "week-1" --color "0052CC" --description "Week 1 assignment" --force
gh label create "week-2" --color "0066FF" --description "Week 2 assignment" --force
gh label create "week-3" --color "1A7FFF" --description "Week 3 assignment" --force
gh label create "week-4" --color "3399FF" --description "Week 4 assignment" --force
gh label create "week-5" --color "4DB3FF" --description "Week 5 assignment" --force
gh label create "week-6" --color "66CCFF" --description "Week 6 assignment" --force

# Type labels - green family (초록 계열)
gh label create "theory" --color "0E8A16" --description "Theory/quiz submission" --force
gh label create "dev" --color "2CBE4E" --description "Development assignment" --force

# Review status labels (per CONTEXT.md: 노란/파란/초록)
gh label create "needs-review" --color "FBCA04" --description "Ready for reviewer" --force
gh label create "in-review" --color "0052CC" --description "Under review" --force
gh label create "approved" --color "0E8A16" --description "Review approved" --force

echo "Done! Created 11 labels:"
echo "  - 6 week labels (week-1 through week-6)"
echo "  - 2 type labels (theory, dev)"
echo "  - 3 status labels (needs-review, in-review, approved)"
