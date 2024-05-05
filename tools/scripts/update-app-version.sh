#!/bin/sh

yq --version || (echo "yq is not installed. Please install yq." && exit 1)
jq --version || (echo "jq is not installed. Please install jq." && exit 1)

current_app_version=$(cat Chart.yaml | yq -r '.appVersion')
echo "Current app version: $current_app_version"

latest_app_version=$(curl -s "https://api.github.com/repos/advplyr/audiobookshelf/releases/latest" | jq -r '.tag_name' | sed 's/^v//')

echo "Latest app version: $latest_app_version"

if [ "$(printf "%s\n%s" "$current_app_version" "$latest_app_version" | sort -V | head -n1)" = "$current_app_version" ]; then
  if [ "$current_app_version" = "$latest_app_version" ]; then
    echo "Current version is equal to the latest version."
    exit 0
  else
    echo "Current version is less than the latest version."
  fi
else
  echo "Current version is greater than the latest version."
  exit 1
fi

echo "Updating app version to $latest_app_version"

yq eval ".appVersion = \"$latest_app_version\"" -i Chart.yaml

echo "Commit and push the changes to the repository."

sh ./tools/scripts/ci-push-changes.sh "fix: update app version to $latest_app_version"
