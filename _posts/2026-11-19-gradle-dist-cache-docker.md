---
layout: post
title:  "How to pre-populate gradle wrapper distribution cache in a Docker image for air-gapped CI"
date:   2026-11-19 00:00:00 -0600
categories: dev
---

Infrastructure is flaky these days, for reasons, so you may be asking yourself _how can I avoid my CI having to download the gradle distribution zip file for every build_? One solution is to pre-populate the gradle wrapper dist cache in your docker image.

Here's how to do it. The first bit of trickery is that we must calculate the hash for the gradlew wrapper `distributionUrl` for every gradle dist you want to support, as gradle expects this hash to be used for the directory name for each cached dist.

> When Gradle downloads a distribution, it caches it locally under `~/.gradle/wrapper/dists/<dist-name>/<url-hash>/`. Gradle's `PathAssembler` class generates this folder name by taking the MD5 hash of the `distributionUrl` string and converting it into a base-36 string.

Since my docker image is used for CI for multiple projects, I needed to support two different gradle versions (8.7 and 9.7.1) and I wanted the flexibility of this working regardless of whether the project is using the public (gradle.org) `distributionUrl` or our internal Nexus registry `distributionUrl`. So I am pre-populating the gradle wrapper dists cache in my image with four `distributionUrl` hash folders:

| URL | hash |
| --- | ---- |
| https://services.gradle.org/distributions/gradle-9.7.1-bin.zip | 1w1c7tv4s851m17nbqdsro2tv |
| https://nexus-repository.company.com/repository/raw-gradle-proxy/gradle-9.7.1-bin.zip | cv1zzq8lsg8quabiq6qkdi2uy |
| https://services.gradle.org/distributions/gradle-8.7-bin.zip | bhs2wmbdwecv87pi65oeuq5iu |
| https://nexus-repository.company.com/repository/raw-gradle-proxy/gradle-8.7-bin.zip | e40uxp50av4z7cuqtc6f720y5 |

You can use a script to calculate these URL hashes, or you can do as I did and embed a bash function in your Dockerfile to calculate them and generate the required `.ok` and `.lck` files.

## Dockerfile

First, I added something like this to my Dockerfile:

```bash
ENV HOME="/home/jenkins"

ENV NEXUS_URL_BASE="https://nexus-repository.company.com/repository"
ENV NEXUS_URL_GRADLE="$NEXUS_URL_BASE/raw-gradle-proxy"
ENV PUBLIC_URL_GRADLE="https://services.gradle.org/distributions"

ENV GRADLE_USER_HOME="$HOME/.gradle"
ENV GRADLE_DISTS_DIR="$GRADLE_USER_HOME/wrapper/dists"
ENV GRADLE_OPTS="-Dhttps.proxyHost=111.222.333.444 -Dhttps.proxyPort=80 -Dhttp.nonProxyHosts='localhost|127.0.0.0/8|::1, github.company.com|jenkins.company.com|nexus-repository.company.com'"
ENV GRADLE_VERSION_LATEST="9.7.1"
ENV GRADLE_VERSION_COMPAT="8.7"

RUN ...
# Download and cache gradle distribution zip file(s)
    && download_gradle_dist() { \
        version=$1 \
        && echo "Downloading gradle-$version-bin.zip distribution.." \
        && curl -k -o "/tmp/gradle-$version-bin.zip" "$NEXUS_URL_GRADLE/gradle-$version-bin.zip"; \
    } \
    && download_gradle_dist $GRADLE_VERSION_LATEST \
    && download_gradle_dist $GRADLE_VERSION_COMPAT \
    && cache_gradle_dist() { \
        version=$1 \
        && url_hash=$2 \
        && dist_hash_dir="$GRADLE_DISTS_DIR/gradle-$version-bin/$url_hash" \
        && echo "Caching gradle-$version-bin.zip distribution into $dist_hash_dir..." \
        && mkdir -p "$dist_hash_dir" \
        && chmod -R a+rwx "$dist_hash_dir" \
        && unzip "/tmp/gradle-$version-bin.zip" -d "$dist_hash_dir" \
        && touch "$dist_hash_dir/gradle-$version-bin.zip.lck" \
        && touch "$dist_hash_dir/gradle-$version-bin.zip.ok" \
        && chmod -R a+rwx "$dist_hash_dir"; \
    } \
    && get_gradle_url_hash() { \
        md5_hex=$(printf "%s" "$1" | md5sum | awk '{print toupper($1)}'); \
        chars="0123456789abcdefghijklmnopqrstuvwxyz"; \
        base36=""; \
        for d in $(printf "obase=36\nibase=16\n%s\n" "$md5_hex" | BC_LINE_LENGTH=0 bc); do \
            d=$(printf "%s" "$d" | sed 's/^0*//'); \
            [ -z "$d" ] && d=0; \
            base36="${base36}$(printf "%s" "$chars" | cut -c$((d + 1)))"; \
        done; \
        printf "%s\n" "${base36:-0}"; \
    } \
    && cache_gradle_dist_nexus_and_public_url() { \
        version=$1 \
        && cache_gradle_dist $version $(get_gradle_url_hash "$PUBLIC_URL_GRADLE/gradle-${version}-bin.zip") \
        && cache_gradle_dist $version $(get_gradle_url_hash "$NEXUS_URL_GRADLE/gradle-${version}-bin.zip"); \
    } \
    && cache_gradle_dist_nexus_and_public_url $GRADLE_VERSION_LATEST \
    && cache_gradle_dist_nexus_and_public_url $GRADLE_VERSION_COMPAT \
...
```

## Jenkinsfile

Next, for my Jenkinsfile, I made it copy `.gradle/wrapper/dists` from the `jenkins` user home directory into the jenkins workspace root, which I am setting as my `GRADLE_USER_HOME`. It may be possible to get it working without this copy step depending on your specific CI setup (in mine `HOME` was already being set to the workspace root, and `${WORKSPACE}/.gradle` gets cleared after each build, or so I read).

I also added logging to verify that the dists are present in the image and have the necessary `.ok` and `.lck` files.

```bash
environment {
        GRADLE_USER_HOME = "${WORKSPACE}/.gradle"
        GRADLE_JDK = '/usr/lib/jvm/java-25-openjdk'
        GRADLE_CMD = "./gradlew -Dorg.gradle.java.home=${GRADLE_JDK}"
}
```
...

```bash
                stage('Build') {
                    steps {
                        script {
                            setupGradleEnvironment();
                        }
                        sh "${GRADLE_CMD} clean build -x test"
```
...

```bash
void logGradleDistCache(String gradleUserHome) {
    sh """
        echo "=== Gradle Wrapper Dists Cache (${gradleUserHome}) ==="
        find "${gradleUserHome}/wrapper/dists" -maxdepth 4 2>/dev/null -type f \\( -name "*.ok" -o -name "*.lck" \\) || echo "No wrapper dists directory found"
    """
}

def setupGradleEnvironment() {
    // log source cache contents, to be copied
    logGradleDistCache("/home/jenkins/.gradle")
    sh '''
        echo "=== Gradle Wrapper Dists Cache Setup ==="
        echo "Copying cached gradle wrapper dists into $GRADLE_USER_HOME/wrapper/..."
        mkdir -p "$GRADLE_USER_HOME/wrapper"
        cp -rn /home/jenkins/.gradle/wrapper/dists "$GRADLE_USER_HOME/wrapper/"
        echo "=== Gradle Environment ==="
        echo "HOME: $HOME | GRADLE_USER_HOME: ${GRADLE_USER_HOME:-not set}"
    '''
    // log dest cache contents, post-copy
    logGradleDistCache("${GRADLE_USER_HOME}:-$HOME/.gradle}")
}
```

## Verification

To verify that it's working, inspect your Jenkins build log and you should no longer see this output:

```bash
Downloading https://services.gradle.org/distributions/gradle-9.7.1-bin.zip
.........................................................................
```
