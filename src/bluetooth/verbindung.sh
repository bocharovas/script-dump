#!/bin/sh

bluetoothctl connect 46:64:02:F5:6F:AE
sleep 5s
pacmd set-card-profile bluez_card.46_64_02_F5_6F_AE handsfree_head_unit
pacmd set-default-source bluez_source.46_64_02_F5_6F_AE.handsfree_head_unit
pacmd set-default-sink bluez_sink.46_64_02_F5_6F_AE.handsfree_head_unit
