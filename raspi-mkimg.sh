#!/bin/sh

# modified from https://blog.csdn.net/talkxin/article/details/50456282 by PaulYoung_Blog

df=`df -P | grep /dev/root | awk '{print $3}'`
dr=`df -P | grep /dev/mmcblk0p1 | awk '{print $2}'`
df=`echo $df $dr |awk '{print int(($1+$2)*1.2)}'`
sudo dd if=/dev/zero of=raspberrypi.img bs=1K count=$df
sudo parted raspberrypi.img --script -- mklabel msdos
start=`sudo fdisk -l /dev/mmcblk0|grep /dev/mmcblk0p1|awk '{print $2}'`
start=`echo $start's'`
end=`sudo fdisk -l /dev/mmcblk0|grep /dev/mmcblk0p1|awk '{print $3}'`
end2=`sudo fdisk -l /dev/mmcblk0|grep /dev/mmcblk0p2|awk '{print $2}'`
end=`echo $end's'`
end2=`echo $end2's'`
echo $start
echo $end
echo $end2

sudo parted raspberrypi.img --script -- mkpart primary fat32 $start $end
sudo parted raspberrypi.img --script -- mkpart primary ext4 $end2 -1

loopdevice=`sudo losetup -f --show raspberrypi.img`
device=`sudo kpartx -va $loopdevice | sed -E 's/.*(loop[0-9])p.*/\1/g' | head -1`
device="/dev/mapper/${device}"
partBoot="${device}p1"
partRoot="${device}p2"
sleep 1

sudo mkfs.vfat $partBoot
sudo mkfs.ext4 $partRoot
echo $partBoot
echo $partRoot

sudo rm -rf /dddd
sudo mkdir /dddd

sudo mount -t vfat $partBoot /dddd
sudo cp -rfp /boot/* /dddd/
sudo umount /dddd
sudo mount -t ext4 $partRoot /dddd
cd /dddd
sudo rsync -aplP --exclude="raspberrypi.img" --exclude=/dddd/* --exclude=/sys/* --exclude=/proc/*  --exclude=/tmp/* / ./
cd
sudo umount /dddd
sudo kpartx -d $loopdevice
sudo losetup -d $loopdevice

