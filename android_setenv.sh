#! /bin/bash
DEVTOOLS_DIR="$HOME/DevTools"
JDK_ROOT_DIR="$DEVTOOLS_DIR/JDK"
ANDROID_HOME="$DEVTOOLS_DIR/Android"
ANDROID_NDK_HOME="$ANDROID_HOME/ndk-bundle"
android_toolchain_file="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake"
ANDROID_ENVS=("ANDROID_HOME" "ANDROID_NDK_HOME" "android_toolchain_file")
for ENV in "${ANDROID_ENVS[@]}"; do
    if [ ! -e ${!ENV} ]; then
        echo "$ENV cannot be found!!"
        exit 1
    else
        cmd="export $ENV=${!ENV}"
        echo $cmd
    fi
done

if [ ! -d $JDK_RO0T_DIR ]; then
    echo "$JDK_ROOT_DIR cannot be found!"
    exit 1
fi
JDK_DIRS=($(ls -dr /home/eli/DevTools/JDK/jdk-11*))
if [ "${#JDK_DIRS[@]}" -gt "0" ]; then
    cmd="export JAVA_HOME=${JDK_DIRS[0]}"
    echo $cmd
    $cmd
else
    echo "try to download OpenJDK11U-jdk_x64_linux_hotspot_20XX-MM-DD-HH-MM.tar.gz  at https://github.com/AdoptOpenJDK/openjdk11-binaries/releases"
    echo "and extract it to $JDK_ROOT_DIR/jdk-11.x.xx+x"
    exit 1
fi

