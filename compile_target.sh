#!/bin/bash
#
# Compile custom linux kernel for raspberry pi 2w
#


# Get image type
TYPE=$1

# Check valid
if [[ -z "$TYPE" || ( "$TYPE" != "destop" && "$TYPE" != "lite" ) ]] ; then
    echo "Please specify desktop or lite"
    echo "ie: $0 desktop or $0 lite"
    echo "desktop is required for VNC functionality"
    exit -1
fi

# Get latest RPI image
if [[ "TYPE" == "desktop" ]]; then
    LATEST=$(wget -O /dev/null -o - --max-redirect=0 https://downloads.raspberrypi.org/raspios_armhf_latest 2>/dev/null| sed -n "s/^Location: \(.*\) \[following\]$/\1/p")
else
    LATEST=$(wget -O /dev/null -o - --max-redirect=0 https://downloads.raspberrypi.org/raspios_lite_armhf_latest 2>/dev/null| sed -n "s/^Location: \(.*\) \[following\]$/\1/p")
fi

# Get SHA256
echo "Get latest raspios sha256"
wget -q $LATEST.sha256
SHA256_FILE=$(basename $LATEST.sha256)
SHA256=$(cat $SHA256_FILE | sed 's/|/ /' | awk '{print $1}')
rm $SHA256_FILE
echo "SHA256: $SHA256"

# Compare against image on disk
echo "Calc SHA256 of local image"
SUM=$(sha256sum raspios.img.xz | sed 's/|/ /' | awk '{print $1}')
echo "SHA256: $SUM"

# Compare to image on disk
if [[ "$SHA256" == "$SUM" ]]; then
    echo "Image up-to-date"
else
    echo "Downloading latest image"
    wget -q --show-progress -O raspios.img.xz $LATEST
fi

# Unzip and mount image
echo "Extracting raspios image"
cp raspios.img.xz temp.xz
unxz temp.xz
mv temp raspios.img

echo "Mounting image"
mkdir -p mnt/fat32 mnt/ext4
LOOP=$(sudo losetup -P --find --show raspios.img)
sudo mount -t vfat ${LOOP}p1 mnt/fat32
sudo mount -t ext4 ${LOOP}p2 mnt/ext4

# Install dependencies and toolchain
echo "Installing kernel compile dependencies"
sudo apt install -y git bc bison flex libssl-dev make libc6-dev libncurses5-dev
sudo apt install -y crossbuild-essential-armhf

# Update kernel source
echo "Updating linux kernel"
cd linux
git co -- .
git clean -d -f
git submodule update

# Apply patches
echo "Applying patches"
for FILE in ../patch/kernel/*
do patch -p1 --forward < $FILE
done

# Compiling kernel
echo "Configuring kernel"
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig

echo "Compiling kernel"
make -j ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

echo "Installing kernel"
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=../mnt/ext4 modules_install
sudo cp ../mnt/fat32/$KERNEL.img ../mnt/fat32/$KERNEL-backup.img
sudo cp arch/arm/boot/zImage ../mnt/fat32/$KERNEL.img
sudo cp arch/arm/boot/dts/*.dtb ../mnt/fat32/
sudo cp arch/arm/boot/dts/overlays/*.dtb* ../mnt/fat32/overlays/
sudo cp arch/arm/boot/dts/overlays/README ../mnt/fat32/overlays/
cd ../

# Patching boot files
echo "Patching bootfs"
for FILE in patch/fat32/*
do sudo patch -p1 --forward < $FILE
done

# Add framework
echo "Installing supercomputer framework..."
sudo mkdir -p mnt/ext4/opt/sc/
sudo cp -R install/ mnt/ext4/opt/sc/

# Copy boot script and logo
sudo cp boot.sh mnt/ext4/opt/sc/
sudo cp boot_logo.png mnt/ext4/opt/sc/

# Build UI framework and install
sudo apt install python3-setuptools python3-wheel python3-build
cd install/sc-python
git submodule update
sudo cp repo.list ../../mnt/ext4/opt/sc/
cd sc_ui/
python3 -m build .
sudo cp dist/sc_ui*.whl ../../../mnt/ext4/opt/sc/install/
cd ../../../

# Enable services
echo "Enabling systemd services..."
for FILE in systemd/*; do
    sudo cp $FILE 'mnt/ext4/usr/lib/systemd/system/'
    FILE=$(basename $FILE)
    sudo ln -s "/usr/lib/systemd/system/${FILE}" "mnt/ext4/etc/systemd/system/multi-user.target.wants/${FILE}"
done

# Cleanup
echo "Cleaning up..."
sudo umount mnt/fat32
sudo umount mnt/ext4
sudo losetup -D $LOOP
rm -rf mnt/

# Compressing resulting image
echo "Compressing supercomputer image..."
xz -4 -c raspios.img > supercomputer.img.xz
rm raspios.img

# Finished
echo "Done"
