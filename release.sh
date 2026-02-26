#!/bin/bash

set -eE # same as: `set -o errexit -o errtrace`
trap 'catch $? $LINENO' ERR

catch() {
  echo "Error $1 occurred on line $2"
}

checkbin() {
  local cmd=$1
  if ! command -v $cmd &> /dev/null; then
    echo "$cmd command could not be found"
    exit
  fi
}

prepareChangelog() {
  local sourceFile=$1
  local targetFile=$2

  rm -rf changelog-tmp
  mkdir changelog-tmp

  # Remove footer section with all link URLs from changelog
#######################  sed -n '/linksnurls/q;p' $1 > changelog-tmp/CHANGELOG2.md
  # Until a new nsd release is made with the "linksnurls" footer marker, the
  # following line has to be used to cut off the footer instead:
  sed -n '/redmine/q;p' $sourceFile > changelog-tmp/CHANGELOG2.md

  # Remove all link brackets from nas changelog
  sed 's|[\[,]||g' changelog-tmp/CHANGELOG2.md > changelog-tmp/CHANGELOG3.md
  sed 's|[],]||g' changelog-tmp/CHANGELOG3.md > $targetFile

  rm -rf changelog-tmp
}

downloadFromNexus() {
  local version=$1
  local groupId=$2
  local artifactId=$3
  local type=$4
  local classifier=$5

  local repository='releases'
  if [[ $version =~ "SNAPSHOT" ]]; then
    repository='snapshots'
  fi

  local query="http://nexus-bob.u-s-p.local/service/rest/v1/search/assets?sort=version&maven.baseVersion=$version&maven.groupId=$groupId&maven.artifactId=$artifactId&maven.extension=$type&maven.classifier=$classifier"
  echo "Nexus query: $query"

  wget -O info.json $query
  downloadUrl=`cat info.json | grep -v '\-sources' | grep -a -m 1 -h "downloadUrl" | grep -Po 'downloadUrl" : "\K[^"]*'`
  rm info.json

  if [[ -z "$classifier" ]]; then
    filename=$artifactId-$version.$type
  else
    filename=$artifactId-$version-$classifier.$type
  fi

  wget -O $filename $downloadUrl
  if [[ "$type" == "zip" || "$type" == "jar" ]]; then
    jar xvf $filename
  fi
}

checkbin mkdocs
checkbin wget

if [ "$#" -lt 1 ]
then
  echo "Not enough arguments supplied. Usage:"
  echo ""
  echo "./release.sh <nas version, e.g. 15.3.2> [deploy]"
  echo ""
  echo "If the optional 'deploy' argument is set, the website will be deployed to Github and made public!"
  echo ""
  echo "Example for creating the website without deployment:"
  echo ""
  echo "./release.sh 15.3.2"
  exit 1
fi

# 1st input parameter = Core Authenticate container version (equals NAS version)
export NAS_VERSION=$1

DIR=`pwd`
rm -rf build
rm -rf docs
rm -rf generated
mkdir build
cd build

echo "-------------------------------------------------------------"
echo "Selected NAS release: $NAS_VERSION"
echo "-------------------------------------------------------------"

mkdir nas-docs
cd nas-docs

# Download NAS release notes
####downloadFromNexus $NAS_VERSION com.usp.nas nas-release-notes jar

# Download generated docs bundle (PDFs and HTML)
downloadFromNexus $NAS_VERSION com.usp.nas nas-docs zip bundle

# Download release notes markdown
downloadFromNexus $NAS_VERSION com.usp.nas nas-docs md releasenotes

rm -f *.zip
rm -f *.jar

# =====================================================================
# Begin site build
# =====================================================================

# Prepare site source directory
cd $DIR

# Copy base markdown files from sources
cp -R src/docs ./docs
cp build/nas-docs/nas-release-notes.html ./docs/

mkdir -p ./docs/files/$NAS_VERSION
cp -r ./build/nas-docs/* ./docs/files/$NAS_VERSION/
cp ./build/nas-docs/nas-docs-$NAS_VERSION-releasenotes.md ./docs/release-notes.md

# Replace version placeholders in all markdown files
for file in ./docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%NAS_VERSION%/'$NAS_VERSION'/g' $file
    fi
done

echo "Successfully generated site (Markdown) at ./docs."

echo "Deployment version: ${version}"

[ "$2" == "deploy" ] && DEPLOY=true && shift
[ "$2" == "--latest" ] && RELEASE_ALIAS=latest && shift

if [ $DEPLOY ]; then
    version=$(echo "$NAS_VERSION" | sed -E 's/^v?([0-9]+)\.([0-9]+)\.[0-9]+$/\1.x/')
    echo "Deploying to GitHub pages with version ${version}..."
    mike deploy --update-aliases --push "${version}" $RELEASE_ALIAS
    echo "Successfully deployed to to GitHub pages"
else
    echo "Building website locally in 'generated' subfolder..."
    mkdocs build
    echo "Website generated."
fi

if [[ $DEPLOY && "${RELEASE_ALIAS}" == "latest" ]]; then
    echo "Setting default latest..."
    sleep 60
    mike set-default --push --allow-empty "${RELEASE_ALIAS}"
    echo "Set default latest."
fi

trap - ERR
