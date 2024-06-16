
sudo true

sleep 3

sudo dfu-programmer atmega32u4 erase
sudo dfu-programmer atmega32u4 flash QMKool_corne_layout.hex 
sudo dfu-programmer atmega32u4 reset
