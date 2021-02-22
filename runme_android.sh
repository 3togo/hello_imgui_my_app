#! /bin/bash
BUILD_DIR=build_android
./external/hello_imgui/tools/sdl_download.sh
source ./android_setenv.sh
# Step 1: select your abi
export android_abi=armeabi-v7a
[ -d $BUILD_DIR ] || mkdir -p $BUILD_DIR
cd $BUILD_DIR
# Step 2: run cmake with option -DHELLOIMGUI_CREATE_ANDROID_STUDIO_PROJECT=ON
cmake \
    -DCMAKE_TOOLCHAIN_FILE=$android_toolchain_file \
    -DANDROID_ABI=$android_abi \
    -DHELLOIMGUI_USE_SDL_OPENGL3=ON \
    -DHELLOIMGUI_CREATE_ANDROID_STUDIO_PROJECT=ON \
    ..
# Step 3: open the project hello_AndroidStudio/ with Android Studio
# And build / debug the app!
# Alternatively, via the command line:
cd hello_AndroidStudio
./gradlew build
#./gradlew installDebug
