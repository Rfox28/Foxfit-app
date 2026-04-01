#!/bin/bash
# Fox Fit — GitHub Pages Publisher
# Run this any time you want to republish after making changes in Claude
# Usage: bash publish.sh

set -e

REPO="foxfit"   # Change this if you named your GitHub repo differently
BRANCH="gh-pages"

echo ""
echo "╔══════════════════════════════════╗"
echo "║     FOX FIT — PUBLISHER          ║"
echo "╚══════════════════════════════════╝"
echo ""

# Check git is installed
if ! command -v git &> /dev/null; then
  echo "✗ Git not found. Install from https://git-scm.com"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# First time setup
if [ ! -d ".git" ]; then
  echo "Setting up git repo for the first time..."
  git init
  git checkout -b $BRANCH
  echo ""
  echo "Enter your GitHub username:"
  read GITHUB_USER
  git remote add origin "https://github.com/$GITHUB_USER/$REPO.git"
  echo ""
  echo "Before continuing:"
  echo "  1. Go to https://github.com/new"
  echo "  2. Create a repo named: $REPO"
  echo "  3. Leave it empty (no README)"
  echo ""
  echo "Press Enter when done..."
  read
fi

# Commit and push
echo "Publishing..."
git add -A
git commit -m "Fox Fit update $(date '+%d %b %Y %H:%M')" || echo "(nothing new to commit)"
git push -u origin $BRANCH --force

echo ""
echo "✓ Published!"
echo ""
echo "Your app URL (may take 1-2 mins first time):"
# Try to get the remote URL
REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [[ $REMOTE == *"github.com"* ]]; then
  USER=$(echo $REMOTE | sed 's/.*github.com[:/]//;s/\/.*//')
  echo "  https://$USER.github.io/$REPO"
fi
echo ""
echo "On your iPhone: open the URL in Safari → Share → Add to Home Screen"
