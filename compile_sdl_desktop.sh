#!/usr/bin/env bash
BUILD_DIR=build_android
WD=$(dirname "$(readlink -f "$0")")
echo "change directory to $WD"
cd $WD

# Step 1: update submodule recursively
git submodule update --init --recursive

# Step 2: install third paties via vcpkg
python ./external/hello_imgui/tools/vcpkg_install_third_parties.py

# Step 3: run cmake using vcpkg toolchain
build_dir=build_sdl
if [ ! -d $build_dir ]; then
    mkdir $build_dir
fi
cd $build_dir
rm * -rf
cmake .. -DCMAKE_TOOLCHAIN_FILE=../external/hello_imgui/vcpkg/scripts/buildsystems/vcpkg.cmake -DHELLOIMGUI_USE_SDL_OPENGL3=ON

# Step 4: build
make -j $(($(nproc)-1))

# Step 5: run the app
./hello
