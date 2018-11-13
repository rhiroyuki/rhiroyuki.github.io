#!/bin/bash

# Automated deploy script with Circle CI.
# source: https://github.com/nielsenramon/kickster/blob/master/snippets/circle/automated
# adapted for github users

# Exit if any subcommand fails.
set -e

# Variables
ORIGIN_URL=`git config --get remote.origin.url`

echo "Started deploying"

# Checkout develop branch.
if [ `git branch | grep develop` ]
then
  git checkout develop
fi

# Build site.
bundle exec jekyll build

# Delete and move files.
find . -maxdepth 1 ! -name '_site' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;
mv _site/* .
rm -R _site/

# Push to develop.
git config user.name "$USER_NAME"
git config user.email "$USER_EMAIL"

git add -fA
git commit --allow-empty -m "$(git log -1 --pretty=%B) [ci skip]"
git push -f $ORIGIN_URL develop:master

# Move back to previous branch.
git checkout -

echo "Deployed Successfully!"

exit 0
