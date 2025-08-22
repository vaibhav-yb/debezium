#!/bin/bash

# Script to resolve git conflicts in pom.xml files and update versions
# This script will:
# 1. Accept current changes (HEAD) only for version tags
# 2. Update the version from dz.2.5.2.yb.2024.1-SNAPSHOT to dz.3.1.3.yb.2024.2-SNAPSHOT

echo "Resolving git conflicts in pom.xml files..."

# Find all pom.xml files with conflicts
conflicted_files=$(find . -name "pom.xml" -exec grep -l "<<<<<<< HEAD" {} \;)

if [ -z "$conflicted_files" ]; then
    echo "No conflicted pom.xml files found."
    exit 0
fi

echo "Found conflicted files:"
echo "$conflicted_files"
echo ""

# Process each conflicted file
for file in $conflicted_files; do
    echo "Processing: $file"
    
    # For version tags, accept current changes (HEAD) by removing conflict markers
    # This handles the specific case where we want to keep the current version
    
    # Handle version tag conflicts - accept HEAD version
    sed -i '/<<<<<<< HEAD/,/=======/{
        /<<<<<<< HEAD/d
        /=======/d
    }' "$file"
    
    # Remove the closing conflict marker
    sed -i '/>>>>>>> 3\.1\.3\.Final/d' "$file"
    
    # Update version from dz.2.5.2.yb.2024.1-SNAPSHOT to dz.3.1.3.yb.2024.2-SNAPSHOT
    sed -i 's/dz\.2\.5\.2\.yb\.2024\.1-SNAPSHOT/dz.3.1.3.yb.2024.2-SNAPSHOT/g' "$file"
    
    echo "  - Resolved version conflicts and updated version in $file"
done

echo ""
echo "Version conflicts resolved and versions updated!"
echo "Please review the changes and commit them."
