#!/usr/bin/env bash

if [[ "$*" != *-android* ]] && [[ "$*" != *-ios* ]]
  then
    echo -e "\033[0;31mAt least one of the following arguments are required to build didkit:\033[0m
    \033[0;36m-android\033[0m: builds didkit's Android binaries
    \033[0;36m-ios\033[0m: builds didkit's iOS binaries
"
    exit
fi

## Checks for rustup installation, installs it and sets to nightly
if ! command -v rustup &> /dev/null
then
    if ! command -v curl &> /dev/null
    then
        sudo apt install curl -y
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        rustup default nightly
    fi
fi

## Checks for java-jdk installation
if ! command -v javac &> /dev/null
then
    sudo apt install default-jdk
fi

## Clones DidKit repo if not yet on previous directory
[ ! -d "../didkit" ] && git clone https://github.com/spruceid/didkit.git ../didkit


## Clones SSI repo if not yet on previous directory
[ ! -d "../ssi" ] && git clone https://github.com/spruceid/ssi.git --recurse-submodules ../ssi

cd ../didkit

[ ! -d "$HOME/Android/Sdk" ] && [ ! -d "$ANDROID_SDK_ROOT" ] && echo -e "\033[0;31mFailed to find Android SDK\033[0m" && exit
[ ! -d "$HOME/Android/Sdk/build-tools" ] && [ ! -d "$ANDROID_TOOLS" ] && echo -e "\033[0;31mFailed to find android-tools\033[0m" && exit
[ ! -d "$HOME/Android/Sdk/ndk" ] && [ ! -d "$ANDROID_NDK_HOME" ] && echo -e "\033[0;31mFailed to find Android NDK\033[0m" && exit

if ! command -v flutter &> /dev/null
then
    echo -e "\033[0;Could not find Flutter, please add to path.\033[0m"
    exit
fi

flutter channel dev
flutter upgrade
flutter doctor --android-licenses

## Builds didkit for Android
if [[ "$*" == *-android* ]]
then
    make -C lib install-rustup-android
    make -C lib ../target/test/java.stamp
    make -C lib ../target/test/aar.stamp
    make -C lib ../target/test/flutter.stamp
fi

## Builds didkit for iOS
if [[ "$*" == *-ios* ]]
then
    make -C lib install-rustup-ios 
    make -C lib ../target/test/ios.stamp
fi

cargo build

