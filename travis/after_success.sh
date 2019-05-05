#!/bin/bash
#
# Tomcat-Slf4j-Logback (https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/)
#
# Copyright (c) 2010-2017 Tomcat-Slf4j-Logback.
#
# All rights reserved. This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution, and is available
# at https://www.eclipse.org/legal/epl-v10.html.
#
# Contributors: Tomcat-Slf4j-Logback Team.
#

# Get Commit Message
commit_message=$(git log --format=%B -n 1)
echo "Current commit detected: ${commit_message}"

# We build for several JDKs on Travis.
# Some actions, like analyzing the code (Coveralls) and uploading
# artifacts on a Maven repository, should only be made for one version.
 
# If the version is 1.8, then perform the following actions.
# 1. Upload artifacts to Sonatype.
#    a. Use -q option to only display Maven errors and warnings.
#    b. Use --settings to force the usage of our "settings.xml" file.

if [ $TRAVIS_REPO_SLUG == "tomcat-slf4j-logback/tomcat-slf4j-logback" ] && [ $TRAVIS_PULL_REQUEST == "false" ] && [ $TRAVIS_BRANCH == "master" ] && [[ "$commit_message" != *"[maven-release-plugin]"* ]]; then

  if [ $TRAVIS_JDK_VERSION == "oraclejdk8" ]; then
    # Deploy sonatype (clean is required to avoid duplication issues in deployment)
    ./mvnw clean deploy -q --settings ./travis/settings.xml
    echo -e "Successfully deployed SNAPSHOT artifacts to Sonatype under Travis job ${TRAVIS_JOB_NUMBER}"

  fi

else
  echo "Travis build skipped"
fi
