#! /bin/bash
BUILD_DIR=build_android
WD=$(dirname "$(readlink -f "$0")")
echo "change directory to $WD"
cd $WD

./external/hello_imgui/tools/sdl_download.sh

DEV_TOOLS="$HOME/DevTools"
if [ ! -e $DEV_TOOLS ]; then
    echo "$DEV_TOOLS cannot be found!!"
    WD=$(dirname "$(readlink -f "$0")")
    echo "change directory to $WD"
    cd $WD
    DEV_TOOLS="$(realpath ../DevTools)"
    if [ ! -e $DEV_TOOLS ]; then
        echo "$DEV_TOOLS cannot be found!!"
        exit 2
    fi
fi
source ./android_setenv.sh $DEV_TOOLS
#DEV_TOOLS=$(realpath ../DevTools)
ANDROID=$DEV_TOOLS/Android
( [ -d $ANDROID ] || ! echo "$ANDROID cannot be found" ) || exit 1
#echo "ANDROID_HOME=$ANDROID_HOME"


# Step 1: select your abi
export android_abi=armeabi-v7a
[ -d $BUILD_DIR ] || mkdir -p $BUILD_DIR
cd $BUILD_DIR
# Step 2: run cmake with option -DHELLOIMGUI_CREATE_ANDROID_STUDIO_PROJECT=ON
#rm CMakeCache.txt

if [ -e "CMakeCache.txt" ]; then
    cmake_build=$(head -n 2 CMakeCache.txt)
    cmake_build=${cmake_build#*:}
    cmake_build="${cmake_build#"${cmake_build%%[![:space:]]*}"}"
    echo "CMAKE BUILD DIR=$cmake_build"
    if [ ! -d "$cmake_build" ]; then
        [ ${#cmake_build} -lt 1 ] && exit 1
        echo "$cmake_build not found"
        cmd="rm CMakeCache.txt"
        echo $cmd
        $cmd
    fi
fi
cmd="cmake \
    -DCMAKE_TOOLCHAIN_FILE=$android_toolchain_file \
    -DANDROID_ABI=$android_abi \
    -DANDROID_HOME=$ANDROID_HOME \
    -DHELLOIMGUI_USE_SDL_OPENGL3=ON \
    -DHELLOIMGUI_CREATE_ANDROID_STUDIO_PROJECT=ON \
    .."
echo $cmd
$cmd
if [ $? -ne 0 ]; then
    echo "cmake failed"
    exit 1
fi
# Step 3: open the project hello_AndroidStudio/ with Android Studio
# And build / debug the app!
# Alternatively, via the command line:
cd hello_AndroidStudio
PROP=local.properties
[[ -f $PROP.backup ]] || mv $PROP $PROP.backup
cat > $PROP << EOF
sdk.dir=$ANDROID
ndk.dir=$ANDROID/ndk-bundle
org.gradle.configureondemand=true
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.workers.max=$(($(nproc)-1))
EOF

./gradlew build
#./gradlew installDebug
