#! /bin/bash

echo "DEV_TOOLS=$DEV_TOOLS"
DEV_TOOLS="${1-$HOME/DevTools}"
echo "DEV_TOOLS=$DEV_TOOLS"
#JDK_ROOT_DIR="$DEV_TOOLS/JDK"
ANDROID_HOME="$DEV_TOOLS/Android"
ANDROID_NDK_HOME="$ANDROID_HOME/ndk-bundle"
android_toolchain_file="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake"
ANDROID_ENVS=("ANDROID_HOME" "ANDROID_NDK_HOME" "android_toolchain_file")
for ENV in "${ANDROID_ENVS[@]}"; do
    if [ ! -e ${!ENV} ]; then
        echo "${!ENV} cannot be found!!"
        exit 1
    else
        cmd="export $ENV=${!ENV}"
        echo $cmd
    fi
done

#if [ ! -d $JDK_RO0T_DIR ]; then
    #echo "$JDK_ROOT_DIR cannot be found!"
    #exit 1
#fi
JAVA_VERSION="11"
JDKS=($(ls -dr /lib/jvm/java-$JAVA_VERSION-openjdk-amd64/))
if [ "${#JDKS[@]}" -lt "1" ]; then
    cmd="sudo apt install openjdk-$JAVA_VERSION-jdk"
    echo $cmd
    $cmd
fi
cmd="export JAVA_HOME=${JDKS[0]}"
echo $cmd
$cmd
export PATH=$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/tools/bin:$PATH
