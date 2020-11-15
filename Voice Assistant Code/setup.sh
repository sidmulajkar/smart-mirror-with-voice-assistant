#!/usr/bin/env bash
#
# Installs required packages, compiles a modified SampleApp 
# from the avs-device-sdk project. https://github.com/alexa/avs-device-sdk
#
# Usage: ./setup.sh
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


# Capture variables for AlexaClientSDKConfig.json
echo -n "Enter your ProductID: "
read productid
echo -n "Enter your ClientID: "
read clientid
echo -n "Enter your DeviceSerialNumber (Can be anything): "
read deviceserial

# Update AlexaClientSDKConfig.json
# ProductId
safe sed -i '15s|.*|        "productId":"'"$productid"'"|' "$CONFIG/AlexaClientSDKConfig.json"
# ClientID
safe sed -i '13s|.*|        "clientId":"'"$clientid"'",|' "$CONFIG/AlexaClientSDKConfig.json"
# deviceSerialNumber
safe sed -i '11s|.*|        "deviceSerialNumber":"'"$deviceserial"'",|' "$CONFIG/AlexaClientSDKConfig.json"
# Update AlexaClientSDKConfig.json with DB file locations
safe sed -i '7s|.*|        "databaseFilePath":"'"$DB"'/cblAuthDelegate.db"|' "$CONFIG/AlexaClientSDKConfig.json"
safe sed -i '38s|.*|        "databaseFilePath":"'"$DB"'/miscDatabase.db"|' "$CONFIG/AlexaClientSDKConfig.json"
safe sed -i '45s|.*|        "databaseFilePath":"'"$DB"'/miscDatabase.db"|' "$CONFIG/AlexaClientSDKConfig.json"
safe sed -i '52s|.*|        "databaseFilePath":"'"$DB"'/settings.db",|' "$CONFIG/AlexaClientSDKConfig.json"
safe sed -i '64s|.*|        "databaseFilePath":"'"$DB"'/certifiedSender.db"|' "$CONFIG/AlexaClientSDKConfig.json"
safe sed -i '71s|.*|        "databaseFilePath":"'"$DB"'/notifications.db"|' "$CONFIG/AlexaClientSDKConfig.json"

# Update UIManager.cpp to use correct location for response.wav
safe sed -i '424s|.*|                system("play '"$CWD"'/sounds/response.wav");|' "$SOURCE/avs-device-sdk/SampleApp/src/UIManager.cpp"


# Install required packages
shout "Installing required packages..."
safe sudo apt-get update --assume-yes
safe sudo apt-get --assume-yes -q install \
    build-essential \
    cmake \
    doxygen \
    gcc \
    gstreamer1.0-plugins-good \
    gstreamer1.0-tools \
    libasound2-dev \
    libatlas-base-dev \
    libcurl4-openssl-dev \
    libfaad-dev \
    libgcrypt20-dev \
    libgstreamer-plugins-bad1.0-dev \
    libsoup2.4-dev \
    libsqlite3-dev \
    python3-pyaudio \
    python-pyaudio \
    sox \
    swig3.0

safe pip install -q commentjson

# Make direcotories
safe mkdir -pv "$BUILD" "$DB"

# Copy asoundrc to home dir
safe cp -v "$CONFIG"/asoundrc ~/.asoundrc

# Build portaudio
shout "Building portaudio..."
safe cd "$SOURCE"/portaudio 
safe ./configure --without-jack
safe make

# Build avs-alexa-sdk
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

echo "Finished!"
echo "Run ./l337.sh run to test"
