#!/usr/bin/env bash
set -e

SOURCE_DIR="${SOURCE_DIR:-$HOME/.shell/scripts/.src}"
SCRIPTS_DIR="${SCRIPTS_DIR:-$HOME/.shell/scripts}"

if [[ -n "${args[--source]}" ]]; then
  SOURCE_DIR="${args[--source]}"
fi
if [[ -n "${args[--out]}" ]]; then
  SCRIPTS_DIR="${args[--out]}"
fi

echo "Scanning for Bashly projects in: $SOURCE_DIR"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Invalid source directory: $SOURCE_DIR"
  exit 1
fi

found_any=false

for project_dir in "$SOURCE_DIR"/*; do
  if [[ -d "$project_dir/src" && -f "$project_dir/src/bashly.yml" ]]; then
    found_any=true
    echo "Processing project: $project_dir"

    (
      cd "$project_dir"
      app_name=$(grep -E '^name:' src/bashly.yml | head -n 1 | awk '{print $2}')

      if [[ -z "$app_name" ]]; then
        echo "Could not determine app name in $project_dir/src/bashly.yml"
        exit 1
      fi

      echo "Generating Bashly app '$app_name'..."
      bashly generate

      if [[ ! -f "$project_dir/$app_name" ]]; then
        echo "Expected generated file '$app_name' not found"
        exit 1
      fi

      echo "Installing to $SCRIPTS_DIR/$app_name"
      mkdir -p "$SCRIPTS_DIR"
      mv "$app_name" "$SCRIPTS_DIR/$app_name"
      chmod +x "$SCRIPTS_DIR/$app_name"
    )
  fi
done

if ! $found_any; then
  echo "No Bashly projects found in $SOURCE_DIR"
fi

echo " Done building all Bashly apps."

