
sudo true
echo 'sleeping for 3 seconds'

sleep 3

sudo dfu-programmer atmega32u4 erase
sudo dfu-programmer atmega32u4 flash my-corne.hex
sudo dfu-programmer atmega32u4 reset
