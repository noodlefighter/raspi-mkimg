# raspi-mkimg
make minimum image file of raspi 3b

## usage

```
# requirement
sudo apt-get install -y dosfstools parted kpartx rsync

# clean
sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove

# do
chmod +x ./raspi-mkimg.sh
sudo ./raspi-mkimg.sh
```

## problem 
hang after "random: crng init done"
https://www.zhihu.com/question/276005891
https://www.zhihu.com/question/276005891
