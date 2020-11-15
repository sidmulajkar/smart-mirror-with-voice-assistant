#!/usr/bin/env bash
# l337.sh
#
# Helper script to run or recompile the SampleApp to test changes
#
# Usage: ./l337.sh [run|rebuild|debug]
#

shout() { echo "$0: $*" >&2; }
barf() { shout "$*"; exit 100; }
safe() { "$@" || barf "ERROR: $*"; }

# Script working directory
CWD="$( cd "$(dirname "$0")" ; pwd )"

# Directory vars
BUILD="$CWD/build"
SOURCE="$CWD/source"
CONFIG="$CWD/config"
DB="$CWD/sqlite-db"

usage (){
  echo -e "Usage: ${0##*/} [run|rebuild|debug]"
  exit 111
}

# Run the SampleApp. ctrl+c to stop.
run(){
    safe cd "$BUILD"/SampleApp/src
    safe ./SampleApp "$BUILD"/Integration/AlexaClientSDKConfig.json "$SOURCE"/snowboy/resources/alexa
}

# Run the SampleApp in debug mode
debug(){
    safe cd "$BUILD"/SampleApp/src
    safe ./SampleApp "$BUILD"/Integration/AlexaClientSDKConfig.json "$SOURCE"/snowboy/resources/alexa DEBUG9
}

# Recompile SampleApp. Uses config changes made from setup.sh
rebuild() {
    shout "Removing files in:"
    shout "$BUILD"
    shout "$DB"
    safe rm -rf "$BUILD"
    safe rm -rf "$DB"
    safe mkdir -pv "$BUILD" "$DB"
    shout "Building avs-alexa-sdk..."
    safe cd "$BUILD"
    safe cmake "$SOURCE"/avs-device-sdk \
        -DKITTAI_KEY_WORD_DETECTOR=ON \
        -DKITTAI_KEY_WORD_DETECTOR_LIB_PATH="$SOURCE"/snowboy/lib/rpi/libsnowboy-detect.a \
        -DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR="$SOURCE"/snowboy/include \
        -DGSTREAMER_MEDIA_PLAYER=ON \
        -DPORTAUDIO=ON \
        -DPORTAUDIO_LIB_PATH="$SOURCE"/portaudio/lib/.libs/libportaudio.a \
        -DPORTAUDIO_INCLUDE_DIR="$SOURCE"/portaudio/include \
        -DCMAKE_CXX_FLAGS:STRING="-D_GLIBCXX_USE_CXX11_ABI=0 -pg" \
        -DCMAKE_BUILD_TYPE=DEBUG
    # Build SampleApp
    safe make SampleApp -j2
    # Update AlexaClientSDKConfig.json
    safe cp -v "$CONFIG"/AlexaClientSDKConfig.json "$BUILD"/Integration/AlexaClientSDKConfig.json
    shout "Done!"
}

# Arg checks
[ $# -lt 0 ] && usage
[ $# -gt 1 ] && usage

case "$1" in
        run) run
             ;;
    rebuild) rebuild
             ;;
      debug) debug
             ;;
          *) usage
             ;;
esac

