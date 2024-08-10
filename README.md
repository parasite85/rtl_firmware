I recommend a cheap DAP-link, I got 12MHz on SWD easily, but STLink should also work  
Use Cygwin if on Windows (or change uname to include CYGWIN).  
open two terminals in `rtl_firmware/project/realtek_ameba1_va0_example/GCC-RELEASE/`  
in #1:  
`export GDB_SERVER=openocd`  
`make setup`  
`make`  
`./run_openocd_stlink.sh` or `./run_openocd_daplink.sh`  
in #2:  
`make flash`  
You can change hostname in `component\common\network\lwip\lwip_v1.4.1\src\core\dhcp.c` (there has to be a better way but this code is spaghetti anyway, it works)  
If you have problems with flashing uncomment `(STRIP) $(BIN_DIR)/$(TARGET).axf` in `rtl_firmware/project/realtek_ameba1_va0_example/GCC-RELEASE/application.mk` (it caused problems with my setup)  
General instruction: https://github.com/parasite85/tuya_tygwzw1_hack
