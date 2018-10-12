#!/bin/bash
#
# (c) Lutfi Akdag (aka Mbtt) - 2018
# Auto-build Script
#

device="$1"
branch="$2"
extra="$3"

echo "========================"
echo "TARGET DEVICE=${device}"
echo "TARGET BRANCH=${branch}"
if [ -z "$extra" ]; then
    echo "TARGET BUILD=system"
else
    echo "TARGET BUILD=${extra}"
fi
echo "========================"

echo "Updating packages..."
sudo apt-get update

echo "Installing Java Development Kit..."
if [ "$branch" == lineage-15.1 ]; then
    sudo apt-get install openjdk-8-jdk
else
    sudo apt-get install openjdk-7-jdk
fi

echo "Installing necessary packages..."
sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git \
             gnupg gperf imagemagicklib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
             libncurses5-dev libsdl1.2-devlibssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop \
             pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev

if [ "$branch" == cm-13.0 ]; then
    echo "Installing Maven Package..."
    sudo apt-get install maven
fi

mkdir -p ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Initialize lineage repositories and sync
if [ -d "lineage" ]; then
    echo "Source already exists."
else
    # Create and navigate to rom folder
    mkdir lineage
    cd lineage
    echo "Starting synchronization..."
    repo init -u https://github.com/LineageOS/android $branch
    repo sync -j32 --no-clone-bundle --no-tags
fi

# Copy roomservice manifest to local_manifests
if [ -n "$device" ]; then
    cd ..
    cp $device.xml lineage/.repo/local_manifests/roomservice.xml
    cd lineage
    repo sync -j32
fi

# Setup build environments
. build/envsetup.sh

# Make lunch
if [ -n "$device" ]; then
    add_combo_lunch lineage_$device-userdebug
fi

# Build
case "$extra" in
    boot)
        echo "Compiling bootimage..."
        make bootimage
        ;;
    recovery)
        echo "Compiling recoveryimage..."
        make recoveryimage
        ;;
    module)
        echo "Type desired modules name:"
        particular=$module
        read -r particular
        echo "Compiling ${module}..."
        make $module
        ;;
    *)
        echo "Compiling full system..."
        brunch $device
        ;;
esac

exit 1
