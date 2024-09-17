#!/bin/bash

PATHTOXPROFILE="/home/mehul/.xprofile"
PATHTOCONFIG="/home/mehul/.config/"
PATHTOZSHRC="/home/mehul/.zshrc"
PATHTOSUCKLESS="/home/mehul/.suckless/"

cd /home/mehul/dotfiles/ || {
  echo "Failed to change directory to /home/mehul/dotfiles/"
  exit 1
}

# Verify we are in a Git repository
if [ ! -d ".git" ]; then
  echo "Not in a Git repository. Please initialize a Git repository in /home/mehul/dotfiles/"
  exit 1
fi

# Copy files and directories with rsync
printf "Copying xprofile..."
rsync -a --delete --recursive --exclude='prepare_dotfiles.sh' --exclude='.git' --exclude='README.md' "$PATHTOXPROFILE" . || {
  echo "Failed to copy xprofile"
  exit 1
}
printf "done.\nCopying .config folder..."
rsync -a --delete --recursive --exclude='prepare_dotfiles.sh' --exclude='.git' --exclude='README.md' "$PATHTOCONFIG" . || {
  echo "Failed to copy .config folder"
  exit 1
}
printf "done.\nCopying .zshrc..."
rsync -a --delete --recursive --exclude='prepare_dotfiles.sh' --exclude='.git' --exclude='README.md' "$PATHTOZSHRC" . || {
  echo "Failed to copy .zshrc"
  exit 1
}
printf "done.\nCopying .suckless (dwm, st, dwmblocks, etc) folder..."
rsync -a --delete --recursive --exclude='prepare_dotfiles.sh' --exclude='.git' --exclude='README.md' "$PATHTOSUCKLESS" . || {
  echo "Failed to copy .suckless folder"
  exit 1
}
printf "done.\n\n-----------------------\n\n"

# Add files to staging area
printf "Adding files to staging area...\n"
git add . || {
  echo "Failed to add files to staging area"
  exit 1
}
printf "Added files. Do you wish to see the staging area? [y/n]: "
read -r see_staging_area

if [[ "$see_staging_area" == "y" ]]; then
  git status
fi

status_text=$(git status)

if [[ "$status_text" == "On branch main\nnothing to commit, working tree clean" ]]; then
  echo "Not needed at all!"
fi

# Commit and push changes
read -r -p "Add a commit message: " message
today=$(date +%Y-%m-%d)
commit_message="${message} ${today}"

git commit -m "$commit_message" || {
  echo "Failed to commit changes"
  exit 1
}
echo "Committed the changes."

git push origin main || {
  echo "Failed to push to origin main"
  exit 1
}
echo "Pushed to origin main."

printf "\nExiting script.\n\n\nHave a nice day!\nMehul A.\nhttps://github.com/mehulambastha\n\n-------------"
