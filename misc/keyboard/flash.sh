
sudo true

select firmware in *.hex ; do break; done

echo 'sleeping for 3 seconds'

sleep 3

sudo dfu-programmer atmega32u4 erase
sudo dfu-programmer atmega32u4 flash $firmware
sudo dfu-programmer atmega32u4 reset
