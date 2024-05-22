#!/bin/bash

rofi -run-list-command ". ~/.config/rofi/bash_aliases" -run-command "/bin/bash -i -c '{cmd}'" -show run
