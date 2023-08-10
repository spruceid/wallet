# Trustchain mobile: installation and developer notes

These instructions are based on the [README](https://github.com/spruceid/credible/blob/main/README.md) from the upstream [Credible](https://github.com/spruceid/credible/).

## Installation

### 1. Install recommended Java version
Install with:
`brew install openjdk@11`

and then add Java to your path by running the suggestion from:
```
brew info openjdk@11 | grep "export PATH"
```

### 2. Create common directory for repos
Create `~/spruceid` directory and clone `didkit`, `ssi` and `trustchain-mobile`:
```bash
mkdir ~/spruceid && cd ~/spruceid

git clone -b dev git@github.com:alan-turing-institute/didkit.git
git clone -b dev --recursive git@github.com:alan-turing-institute/ssi.git
git clone https://github.com/alan-turing-institute/trustchain-mobile.git
```

### 3. Install flutter
The `beta` channel is essential for Mac ARM as the deprecated `dev` channel fails for targets:
```bash
git clone https://github.com/flutter/flutter.git -b beta $HOME/flutter
git checkout 3.7.0-9.0.pre
echo 'export PATH=$HOME/flutter/bin:"$PATH"' >> $HOME/.zshrc
source ~/.zshrc

# Check installation
flutter doctor -v
```

Note: There is currently a dependency issue for flutter version 3.8 (latest version) so a current workaround is to checkout an earlier release (`3.7.0-9.0.pre`).

#### Other potential issues
- If flutter is not able to find java, you can [try](https://stackoverflow.com/a/75119315):
  ```bash
  cd /Applications/Android\ Studio.app/Contents
  ln -s jbr jre
  ```
  Note: in case the `ln` fails, you may need to grant **Full Disk Access** to **Terminal** (Settings > Privacy & Security > Full Disk Access > Drag in Terminal app + Activate toggle). 

- If installing Xcode command line tools with `xcode-select --install` does not work (already installed), then try installing Xcode from the App Store
- If installing CocoaPods from the [suggested instructions](https://guides.cocoapods.org/using/getting-started.html#installation) does not work, then try with: `brew install cocoapods`. 

### 4. Install Android Studio/SDK/NDK

Download and install [Android Studio](https://developer.android.com/studio/install#mac).

Then go to Android Studio > Preferences > search for "SDK"
- SDK Platforms: Tick Android API 33
- SDK Tools:
    - Android SDK Build-Tools
    - NDK (Side by side)
    - Android SDK Command-line Tools (latest)
    - Android Emulator
    - Android SDK Platform-Tools


### 5. Update shell environment variables
Add the following to your `.zshrc` replacing any `y.z` with specific versions:
```
# Add the brew installed openjdk@11
# For intel
# export JAVA_HOME=/usr/local/Cellar/openjdk@11/11.y.z/libexec/openjdk.jdk/Contents/Home
# For ARM
export JAVA_HOME=/opt/local/Cellar/openjdk@11/11.y.z/libexec/openjdk.jdk/Contents/Home

# SDK root
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk

# Note difference from `install_dependencies_script.sh` with 'latest' instead of `tools`
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:"$PATH"
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/lib:"$PATH"

export PATH=$ANDROID_SDK_ROOT/tools:"$PATH"
export PATH=$JAVA_HOME/bin:"$PATH"

# The SDK is from Android studio install: set version as 
export ANDROID_TOOLS=$ANDROID_SDK_ROOT/build-tools/33.y.z
```
With the above in `~/.zshrc`, run:
```
$ . ~/.zshrc
```
to load into the env and then run the following line from the [install_android_dependencies script](https://github.com/alan-turing-institute/trustchain-mobile/blob/dev/install_android_dependencies.sh):
```bash
sdkmanager --sdk_root=$ANDROID_SDK_ROOT --install "platform-tools" "ndk;22.0.7026061"
sdkmanager --licenses
```

The add the NDK to your `.zshrc`:
```
# Version 22.0 (< 23.0) is essential for the NDK as it includes the required
# compilers missing in the more recent NDK installed in Android studio
# directly. This needs to be installed with sdkmanager in command line
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/22.0.7026061
```

### 6. Install LLVM
This is a required dependency for building the targets in step 7.
```bash
brew install llvm 
export TARGET_CC=$(which clang)
```

You may also need to add the llvm bin directory to your path. Run the following to see the instructions for this:
```bash
brew info llvm | grep "export PATH"
```

### 7. Build DIDKit targets
This step provides the builds that provide the DIDKit FFI functionality.

A Rust installation is needed for this step. If necessary, follow the [official instructions](https://www.rust-lang.org/tools/install) including adding `~/.cargo/bin` to your path. 

After installing rust you'll need to restart your shell, in which case you'll also need to re-export `TARGET_CC` from step 6.

Then continue with the actual build from the current repo root location:

```bash
cd ../didkit

make -C lib install-rustup-android
make -C lib ../target/test/java.stamp
make -C lib ../target/test/android.stamp
make -C lib ../target/test/flutter.stamp
cargo build
```

### 8. Make an emulator in Android studio
- Open Android Studio
- Open devices (`Virtual Device Manager` in the `More Actions` dropdown)
- Make a new one with SDK 33 and latest Pixel Pro 6
- Press the play button to start it


### 9. Run flutter to start mobile app
- With an android emulator running from the `trustchain-mobile` repo root:
```bash
flutter run 
```
This runs the code from the branch you have checked out. The mobile app should now start on the emulator.

> **Note:** If you get errors during this step, try to build and run the project in VS Code via the instructions in the [next section](#developing).


## Developing
### Debugging in VS code with hot reload

- Open the repo in VS code
- Install required dart and flutter extensions
- Click on the bottom right to choose the the installed android emulator
- Press `fn-F5` to run from inside VS code and have the app hot reload upon save

### Changes to localizations
- Changes to the localizations (language specific text references), can be written in:
    ```
    lib/l10n/app_en.arb
    lib/l10n/app_fr.arb
    etc
    ```
    with `$ flutter gen-l10n` called from the command line 
