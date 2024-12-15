# Flags
# -------------------------------------------------------------------
SHELL = bash
CONFIG_BT = 0
# -------------------------------------------------------------------
# Initialize tool chain
# -------------------------------------------------------------------
ARM_GCC_TOOLCHAIN = ../../../tools/arm-none-eabi-gcc/4_8-2014q3/bin/
AMEBA_TOOLDIR	= ../../../component/soc/realtek/8195a/misc/iar_utility/common/tools/
FLASH_TOOLDIR = ../../../component/soc/realtek/8195a/misc/gcc_utility/
IMAGE1_DIR = ../../../component/soc/realtek/8195a/misc/bsp/image/

CROSS_COMPILE = $(ARM_GCC_TOOLCHAIN)/arm-none-eabi-

# Compilation tools
STRIP = $(CROSS_COMPILE)strip
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
LD = $(CROSS_COMPILE)gcc
GDB = $(CROSS_COMPILE)gdb
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OS := $(shell uname)

ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
PICK = $(AMEBA_TOOLDIR)pick.exe
PAD  = $(AMEBA_TOOLDIR)padding.exe
CHKSUM = $(AMEBA_TOOLDIR)checksum.exe
ED25519 =  $(AMEBA_TOOLDIR)ed25519.exe
TAIL =  $(AMEBA_TOOLDIR)tail.exe
else
PICK = $(AMEBA_TOOLDIR)pick
PAD  = $(AMEBA_TOOLDIR)padding
CHKSUM = $(AMEBA_TOOLDIR)checksum
ED25519 =  $(AMEBA_TOOLDIR)ed25519
endif

HASH_PY =  $(AMEBA_TOOLDIR)hashing.py
REHEADER_PY =  $(AMEBA_TOOLDIR)reheader.py
SIGN_LEN = 64
SECURE_BOOT = 0

# Initialize target name and target object files
# -------------------------------------------------------------------

all: application manipulate_images

mp: application manipulate_images

TARGET=application

OBJ_DIR=$(TARGET)/Debug/obj
BIN_DIR=$(TARGET)/Debug/bin

# Include folder list
# -------------------------------------------------------------------

INCLUDES =
INCLUDES += -I../inc
INCLUDES += -I../../../component/soc/realtek/common/bsp
INCLUDES += -I../../../component/os/freertos
INCLUDES += -I../../../component/os/freertos/freertos_v8.1.2/Source/include
INCLUDES += -I../../../component/os/freertos/freertos_v8.1.2/Source/portable/GCC/ARM_CM3
INCLUDES += -I../../../component/os/os_dep/include
INCLUDES += -I../../../component/soc/realtek/8195a/misc/driver
INCLUDES += -I../../../component/soc/realtek/8195a/misc/os
INCLUDES += -I../../../component/common/api/network/include
INCLUDES += -I../../../component/common/api
INCLUDES += -I../../../component/common/api/platform
INCLUDES += -I../../../component/common/api/wifi
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src/crypto
INCLUDES += -I../../../component/common/application
INCLUDES += -I../../../component/common/application/iotdemokit
INCLUDES += -I../../../component/common/application/google
ifeq ($(CONFIG_BT), 1)
INCLUDES += -I../../../component/common/bluetooth
endif
INCLUDES += -I../../../component/common/media/framework
INCLUDES += -I../../../component/common/example
INCLUDES += -I../../../component/common/example/wlan_fast_connect
INCLUDES += -I../../../component/common/mbed/api
INCLUDES += -I../../../component/common/mbed/hal
INCLUDES += -I../../../component/common/mbed/hal_ext
INCLUDES += -I../../../component/common/mbed/targets/hal/rtl8195a
INCLUDES += -I../../../component/common/file_system
INCLUDES += -I../../../component/common/network
INCLUDES += -I../../../component/common/network/lwip/lwip_v1.4.1/port/realtek/freertos
INCLUDES += -I../../../component/common/network/lwip/lwip_v1.4.1/src/include
INCLUDES += -I../../../component/common/network/lwip/lwip_v1.4.1/src/include/lwip
INCLUDES += -I../../../component/common/network/lwip/lwip_v1.4.1/src/include/ipv4
INCLUDES += -I../../../component/common/network/lwip/lwip_v1.4.1/port/realtek
INCLUDES += -I../../../component/common/test
INCLUDES += -I../../../component/soc/realtek/8195a/cmsis
INCLUDES += -I../../../component/soc/realtek/8195a/cmsis/device
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/rtl8195a
INCLUDES += -I../../../component/soc/realtek/8195a/misc/platform
INCLUDES += -I../../../component/soc/realtek/8195a/misc/rtl_std_lib/include
INCLUDES += -I../../../component/common/drivers/wlan/realtek/include
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/osdep
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hci
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal/OUTSRC
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/core/option
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/ram_lib/wlan/realtek/wlan_ram_map/rom
INCLUDES += -I../../../component/common/network/ssl/polarssl-1.3.8/include
INCLUDES += -I../../../component/common/network/ssl/mbedtls-2.4.0/include
INCLUDES += -I../../../component/common/network/ssl/ssl_ram_map/rom
INCLUDES += -I../../../component/common/utilities
INCLUDES += -I../../../component/soc/realtek/8195a/misc/rtl_std_lib/include
INCLUDES += -I../../../component/common/application/apple/WACServer/External/Curve25519
INCLUDES += -I../../../component/common/application/apple/WACServer/External/GladmanAES
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/ram_lib/usb_otg/include
INCLUDES += -I../../../component/common/video/v4l2/inc
INCLUDES += -I../../../component/common/media/rtp_codec
INCLUDES += -I../../../component/common/drivers/usb_class/host/uvc/inc
INCLUDES += -I../../../component/common/drivers/usb_class/device
INCLUDES += -I../../../component/common/drivers/usb_class/device/class
INCLUDES += -I../../../component/common/file_system/fatfs
INCLUDES += -I../../../component/common/file_system/fatfs/r0.10c/include
INCLUDES += -I../../../component/common/drivers/sdio/realtek/sdio_host/inc
INCLUDES += -I../../../component/common/audio
INCLUDES += -I../../../component/common/drivers/i2s
INCLUDES += -I../../../component/common/application/xmodem
INCLUDES += -I../../../component/common/application/mqtt/MQTTClient

# Source file list
# -------------------------------------------------------------------

SRC_C =
DRAM_C =
#cmsis
SRC_C += ../../../component/soc/realtek/8195a/cmsis/device/system_8195a.c

#console
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/api/at_cmd/atcmd_bt.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_cloud.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_ethernet.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_lwip.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_mp.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_sys.c
DRAM_C += ../../../component/common/api/at_cmd/atcmd_wifi.c
else
SRC_C += ../../../component/common/api/at_cmd/atcmd_cloud.c
SRC_C += ../../../component/common/api/at_cmd/atcmd_ethernet.c
SRC_C += ../../../component/common/api/at_cmd/atcmd_lwip.c
SRC_C += ../../../component/common/api/at_cmd/atcmd_mp.c
SRC_C += ../../../component/common/api/at_cmd/atcmd_sys.c
SRC_C += ../../../component/common/api/at_cmd/atcmd_wifi.c
endif
SRC_C += ../../../component/common/api/at_cmd/log_service.c
SRC_C += ../../../component/soc/realtek/8195a/misc/driver/low_level_io.c
SRC_C += ../../../component/soc/realtek/8195a/misc/driver/rtl_consol.c

#multimedia - audio_driver
SRC_C += ../../../component/common/drivers/i2s/sgtl5000.c

#network - api
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/src/crypto/tls_polarssl.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_eap_config.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_p2p_config.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_wps_config.c
SRC_C += ../../../component/common/api/wifi/wifi_conf.c
SRC_C += ../../../component/common/api/wifi/wifi_ind.c
SRC_C += ../../../component/common/api/wifi/wifi_promisc.c
SRC_C += ../../../component/common/api/wifi/wifi_simple_config.c
SRC_C += ../../../component/common/api/wifi/wifi_util.c
SRC_C += ../../../component/common/api/lwip_netconf.c

#network - app
SRC_C += ../../../component/common/application/mqtt/MQTTClient/MQTTClient.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTConnectClient.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTConnectServer.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTDeserializePublish.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTFormat.c
SRC_C += ../../../component/common/application/mqtt/MQTTClient/MQTTFreertos.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTPacket.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTSerializePublish.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTSubscribeClient.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTSubscribeServer.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTUnsubscribeClient.c
SRC_C += ../../../component/common/application/mqtt/MQTTPacket/MQTTUnsubscribeServer.c
SRC_C += ../../../component/soc/realtek/8195a/misc/platform/ota_8195a.c
SRC_C += ../../../component/common/api/network/src/ping_test.c
SRC_C += ../../../component/common/utilities/ssl_client.c
SRC_C += ../../../component/common/utilities/ssl_client_ext.c
SRC_C += ../../../component/common/utilities/tcptest.c
SRC_C += ../../../component/common/application/uart_adapter/uart_adapter.c
SRC_C += ../../../component/common/utilities/uart_ymodem.c
SRC_C += ../../../component/common/utilities/update.c
SRC_C += ../../../component/common/api/network/src/wlan_network.c

#network - lwip
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/api_lib.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/api_msg.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/err.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/netbuf.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/netdb.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/netifapi.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/sockets.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/api/tcpip.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/autoip.c
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/icmp.c
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/igmp.c
else
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/autoip.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/icmp.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/igmp.c
endif
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/inet.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/inet_chksum.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/ip.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/ip_addr.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/ipv4/ip_frag.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/def.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/dhcp.c
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/dns.c
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/init.c
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/lwip_timers.c
else
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/dhcp.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/dns.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/init.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/lwip_timers.c
endif
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/mem.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/memp.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/netif.c
else
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/netif.c
endif
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/pbuf.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/raw.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/stats.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/sys.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/tcp.c
else
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/tcp.c
endif
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/tcp_in.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/tcp_out.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/core/udp.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/src/netif/etharp.c
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/port/realtek/freertos/ethernetif.c
SRC_C += ../../../component/common/drivers/wlan/realtek/src/osdep/lwip_intf.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/network/lwip/lwip_v1.4.1/port/realtek/freertos/sys_arch.c
else
SRC_C += ../../../component/common/network/lwip/lwip_v1.4.1/port/realtek/freertos/sys_arch.c
endif
SRC_C += ../../../component/common/network/dhcp/dhcps.c
SRC_C += ../../../component/common/network/sntp/sntp.c

#network - googlenest
SRC_C += ../../../component/common/application/google/google_tls.c

#network - httpc
SRC_C += ../../../component/common/network/httpc/httpc_tls.c

#network - httpd
DRAM_C += ../../../component/common/network/httpd/httpd_tls.c

#network - mdns
SRC_C += ../../../component/common/network/mDNS/mDNSPlatform.c

#network - websocket
SRC_C += ../../../component/common/network/websocket/wsclient_tls.c
SRC_C += ../../../component/common/network/websocket/wsserver_tls.c

#os - freertos
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/portable/MemMang/heap_5.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/portable/GCC/ARM_CM3/port.c
SRC_C += ../../../component/os/freertos/cmsis_os.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/croutine.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/event_groups.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/list.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/queue.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/tasks.c
SRC_C += ../../../component/os/freertos/freertos_v8.1.2/Source/timers.c

#os - osdep
SRC_C += ../../../component/os/os_dep/device_lock.c
SRC_C += ../../../component/os/freertos/freertos_service.c
SRC_C += ../../../component/soc/realtek/8195a/misc/os/mailbox.c
SRC_C += ../../../component/soc/realtek/8195a/misc/os/osdep_api.c
SRC_C += ../../../component/os/os_dep/osdep_service.c
SRC_C += ../../../component/os/os_dep/tcm_heap.c

#peripheral - api
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/analogin_api.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/analogout_api.c
endif
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/dma_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/efuse_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/ethernet_api.c
SRC_C += ../../../component/common/drivers/ethernet_mii/ethernet_mii.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/flash_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/gpio_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/gpio_irq_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/i2c_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/i2s_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/log_uart_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/nfc_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pinmap.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pinmap_common.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/port_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pwmout_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/reset_reason_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/rtc_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/serial_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/sleep.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/spdio_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/spi_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/sys_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/timer_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/us_ticker.c
SRC_C += ../../../component/common/mbed/common/us_ticker_api.c
SRC_C += ../../../component/common/mbed/common/wait_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/wdt_api.c

#peripheral - hal
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_32k.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_adc.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_dac.c
endif
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_gdma.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_gpio.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_i2c.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_i2s.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_mii.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_nfc.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_pcm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_pwm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_sdr_controller.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_ssi.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_timer.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_uart.c

#peripheral - rtl8195a
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_adc.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_dac.c
endif
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_gdma.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_gpio.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_i2c.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_i2s.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_mii.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_nfc.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_pwm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_ssi.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_timer.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_uart.c

#peripheral - wlan
#all:SRC_C += ../../../component/common/drivers/wlan/realtek/src/core/option/rtw_opt_skbuf.c

#SDRAM
DRAM_C += ../../../component/common/api/platform/stdlib_patch.c

ifeq ($(CONFIG_BT), 1)
#SDRAM - bluetooth
DRAM_C += ../../../component/common/bluetooth/bt_conf.c
DRAM_C += ../../../component/common/bluetooth/bt_util.c
DRAM_C += ../../../component/common/bluetooth/ring_buffer.c
endif

#SDRAM - polarssl
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/aes.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/aesni.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/arc4.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/asn1parse.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/asn1write.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/base64.c
SRC_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/bignum.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/blowfish.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/camellia.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ccm.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/certs.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/cipher.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/cipher_wrap.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ctr_drbg.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/debug.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/des.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/dhm.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecp.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecp_curves.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecdh.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecdsa.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/entropy.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/entropy_poll.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/error.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/gcm.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/havege.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/hmac_drbg.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md_wrap.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md2.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md4.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md5.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/memory_buffer_alloc.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/net.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/oid.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/padlock.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pbkdf2.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pem.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs5.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs11.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs12.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pk.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pk_wrap.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkparse.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkwrite.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/platform.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ripemd160.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/rsa.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha1.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha256.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha512.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_cache.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_ciphersuites.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_cli.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_srv.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_tls.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/threading.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/timing.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/version.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/version_features.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_crt.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_crl.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_csr.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_create.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509write_crt.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509write_csr.c
DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/xtea.c

#SDRAM - mbedtls
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/aes.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/aesni.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/arc4.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/asn1parse.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/asn1write.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/base64.c
#SRC_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/bignum.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/blowfish.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/camellia.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ccm.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/certs.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/cipher.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/cipher_wrap.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ctr_drbg.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/debug.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/des.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/dhm.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecp.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecp_curves.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecdh.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecdsa.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/entropy.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/entropy_poll.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/error.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/gcm.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/havege.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/hmac_drbg.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md_wrap.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md2.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md4.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md5.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/memory_buffer_alloc.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/net_sockets.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/oid.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/padlock.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pem.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs5.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs11.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs12.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pk.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pk_wrap.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkparse.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkwrite.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/platform.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ripemd160.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/rsa.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha1.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha256.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha512.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_cache.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_ciphersuites.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_cli.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_srv.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_tls.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/threading.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/timing.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/version.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/version_features.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_crt.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_crl.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_csr.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_create.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509write_crt.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509write_csr.c
#DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/xtea.c

# - ssl wpa3
SRC_C += ../../../component/common/drivers/wlan/realtek/src/core/option/rtw_opt_crypto_ssl.c

#SDRAM - ssl_ram_map
DRAM_C += ../../../component/common/network/ssl/ssl_ram_map/rom/rom_ssl_ram_map.c
DRAM_C += ../../../component/common/network/ssl/ssl_ram_map/ssl_ram_map.c

#SDRAM - wigadget
DRAM_C += ../../../component/common/application/wigadget/cloud_link.c
DRAM_C += ../../../component/common/application/wigadget/shtc1.c
DRAM_C += ../../../component/common/application/wigadget/wigadget.c


#utilities
SRC_C += ../../../component/common/utilities/cJSON.c
SRC_C += ../../../component/common/utilities/http_client.c
SRC_C += ../../../component/common/utilities/uart_socket.c
SRC_C += ../../../component/common/utilities/xml.c

#utilities - example
SRC_C += ../../../component/common/example/amazon_awsiot/example_amazon_awsiot.c
SRC_C += ../../../component/common/example/audio_mp3/example_audio_mp3.c
#SRC_C += ../../../component/common/example/mqtt/example_mqtt.c
SRC_C += ../../../component/common/example/bcast/example_bcast.c
ifeq ($(CONFIG_BT), 1)
DRAM_C += ../../../component/common/example/bt_beacon/example_bt_beacon.c
DRAM_C += ../../../component/common/example/bt_config/example_bt_config.c
DRAM_C += ../../../component/common/example/bt_gatt_client/example_bt_gatt_client.c
DRAM_C += ../../../component/common/example/bt_gatt_server/example_bt_gatt_server.c
DRAM_C += ../../../component/common/example/bt_spp/example_bt_spp.c
endif
SRC_C += ../../../component/common/example/eap/example_eap.c
SRC_C += ../../../component/common/example/example_entry.c
SRC_C += ../../../component/common/example/fatfs/example_fatfs.c
SRC_C += ../../../component/common/example/dct/example_dct.c
SRC_C += ../../../component/common/example/get_beacon_frame/example_get_beacon_frame.c
SRC_C += ../../../component/common/example/googlenest/example_google.c
SRC_C += ../../../component/common/example/high_load_memory_use/example_high_load_memory_use.c
SRC_C += ../../../component/common/example/http_client/example_http_client.c
SRC_C += ../../../component/common/example/http_download/example_http_download.c
SRC_C += ../../../component/common/example/httpc/example_httpc.c
DRAM_C += ../../../component/common/example/httpd/example_httpd.c
SRC_C += ../../../component/common/example/mcast/example_mcast.c
SRC_C += ../../../component/common/example/mdns/example_mdns.c
#SRC_C += ../../../component/common/example/media_multi_stream/example_media_ms.c
#SRC_C += ../../../component/common/example/media_single_stream/example_media_ss.c
#SRC_C += ../../../component/common/example/mjpeg_capture/example_mjpeg.c
SRC_C += ../../../component/common/example/nonblock_connect/example_nonblock_connect.c
SRC_C += ../../../component/common/example/pppoe/example_pppoe.c
SRC_C += ../../../component/common/example/sntp_showtime/example_sntp_showtime.c
SRC_C += ../../../component/common/example/socket_select/example_socket_select.c
DRAM_C += ../../../component/common/example/socket_tcp_trx/example_socket_tcp_trx_1.c
SRC_C += ../../../component/common/example/socket_tcp_trx/example_socket_tcp_trx_2.c
SRC_C += ../../../component/common/example/ssl_download/example_ssl_download.c
SRC_C += ../../../component/common/example/ssl_server/example_ssl_server.c
SRC_C += ../../../component/common/example/tcp_keepalive/example_tcp_keepalive.c
SRC_C += ../../../component/common/example/uart_atcmd/example_uart_atcmd.c
#SRC_C += ../../../component/common/example/uart_firmware_update/example_uart_update.c
SRC_C += ../../../component/common/example/usb_mass_storage/example_usb_msc.c
#SRC_C += ../../../component/common/example/wifi_manager/example_wifi_manager.c
SRC_C += ../../../component/common/example/wlan_fast_connect/example_wlan_fast_connect.c
SRC_C += ../../../component/common/example/wlan_scenario/example_wlan_scenario.c
SRC_C += ../../../component/common/example/websocket_server/example_ws_server.c
SRC_C += ../../../component/common/example/websocket_client/example_wsclient.c
SRC_C += ../../../component/common/example/xml/example_xml.c
#SRC_C += ../../../component/common/example/s3_upload/example_s3_upload.c

#utilities - FatFS
SRC_C += ../../../component/common/file_system/fatfs/fatfs_ext/src/ff_driver.c
SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/diskio.c
SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/ff.c
SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/option/ccsbcs.c
SRC_C += ../../../component/common/file_system/fatfs/disk_if/src/sdcard.c

#utilities - xmodme update
SRC_C += ../../../component/common/application/xmodem/uart_fw_update.c

#gcc wrap
SRC_C += ../../../component/soc/realtek/8195a/misc/platform/gcc_wrap.c
SRC_C += ../../../component/common/api/platform/gcc_wrap_time.c

#user 
SRC_C += ../src/main.c

# Generate obj list
# -------------------------------------------------------------------

SRC_O = $(patsubst %.c,%.o,$(SRC_C))
DRAM_O = $(patsubst %.c,%.o,$(DRAM_C))

SRC_C_LIST = $(notdir $(SRC_C)) $(notdir $(DRAM_C))
OBJ_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.o,$(SRC_C_LIST)))
DEPENDENCY_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.d,$(SRC_C_LIST)))

# Compile options
# -------------------------------------------------------------------

CFLAGS =
CFLAGS += -DM3 -DCONFIG_PLATFORM_8195A -DGCC_ARMCM3
CFLAGS += -mcpu=cortex-m3 -mthumb -g2 -w -Os -Wno-pointer-sign -fno-common -fmessage-length=0  -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-short-enums -DF_CPU=166000000L -std=gnu99 -fsigned-char
CFLAGS += -include time64_gcc.h

LFLAGS = 
LFLAGS += -mcpu=cortex-m3 -mthumb -g --specs=nano.specs -nostartfiles -Wl,-Map=$(BIN_DIR)/application.map -Os -Wl,--gc-sections -Wl,--cref -Wl,--entry=Reset_Handler -Wl,--no-enum-size-warning -Wl,--no-wchar-size-warning
LFLAGS += -Wl,-wrap,malloc -Wl,-wrap,free -Wl,-wrap,realloc -Wl,-wrap,_malloc_r -Wl,-wrap,_free_r -Wl,-wrap,_realloc_r
LFLAGS += -Wl,-wrap,localtime -Wl,-wrap,mktime
LFLAGS += -Wl,-wrap,rom_psk_CalcGTK
LFLAGS += -Wl,-wrap,rom_psk_CalcPTK
LFLAGS += -Wl,-wrap,aes_80211_encrypt
LFLAGS += -Wl,-wrap,aes_80211_decrypt

LIBFLAGS =
ifeq ($(CONFIG_BT), 1)
all: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_bt -l_platform -l_wlan -l_btsdk -l_eap -l_http -l_dct -l_p2p -l_wps -l_rtlstd -l_usbd -l_sdcard -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
mp: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_bt -l_platform -l_wlan_mp -l_btsdk -l_p2p -l_wps -l_rtlstd -l_dct -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
else
all: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_platform -l_wlan -l_eap -l_http -l_dct -l_p2p -l_wps -l_rtlstd -l_usbd -l_sdcard -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
mp: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_platform -l_wlan_mp -l_p2p -l_wps -l_rtlstd -l_dct -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
endif

RAMALL_BIN =
OTA_BIN = 
all: RAMALL_BIN = ram_all.bin
all: OTA_BIN = ota.bin
mp: RAMALL_BIN = ram_all_mp.bin
mp: OTA_BIN = ota_mp.bin

# Compile
# -------------------------------------------------------------------

.PHONY: application
application: prerequirement build_info $(SRC_O) $(DRAM_O)
	$(LD) $(LFLAGS) -o $(BIN_DIR)/$(TARGET).axf  $(OBJ_LIST) $(OBJ_DIR)/ram_1.r.o $(LIBFLAGS) -T./rlx8195A-symbol-v02-img2.ld
	$(OBJDUMP) -d $(BIN_DIR)/$(TARGET).axf > $(BIN_DIR)/$(TARGET).asm


# Manipulate Image
# -------------------------------------------------------------------
	
.PHONY: manipulate_images
manipulate_images:	
	@echo ===========================================================
	@echo Image manipulating
	@echo ===========================================================
#	$(STRIP) $(BIN_DIR)/$(TARGET).axf
	$(NM) $(BIN_DIR)/$(TARGET).axf | sort > $(BIN_DIR)/$(TARGET).nmap
	$(OBJCOPY) -j .image2.start.table -j .ram_image2.text -j .ram_image2.rodata -j .ram.data -Obinary $(BIN_DIR)/$(TARGET).axf $(BIN_DIR)/ram_2.bin
	$(OBJCOPY) -j .sdr_text -j .sdr_rodata -j .sdr_data -Obinary $(BIN_DIR)/$(TARGET).axf $(BIN_DIR)/sdram.bin
	cp $(IMAGE1_DIR)/ram_1.p.bin $(BIN_DIR)/ram_1.p.bin
	chmod 777 $(BIN_DIR)/ram_1.p.bin
ifeq ($(SECURE_BOOT),1)
	chmod +rx $(PICK) $(CHKSUM) $(PAD) $(ED25519)
else
	chmod +rx $(PICK) $(CHKSUM) $(PAD)
endif

	$(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.p.bin body+reset_offset+sig
	$(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.ns.bin body+reset_offset
	$(PICK) 0x`grep __sdram_data_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __sdram_data_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/sdram.bin $(BIN_DIR)/ram_3.p.bin body+reset_offset

ifeq ($(SECURE_BOOT),1)
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(TAIL) -c +17 $(BIN_DIR)/ram_2.p.bin > $(BIN_DIR)/ram_2_for_hash.p.bin
else
	tail -c +17 $(BIN_DIR)/ram_2.p.bin > $(BIN_DIR)/ram_2_for_hash.p.bin
endif
	python $(HASH_PY) $(BIN_DIR)/ram_2_for_hash.p.bin
	cp output.bin hash_sum_2.bin
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(TAIL) -c +17 $(BIN_DIR)/ram_3.p.bin > $(BIN_DIR)/ram_3_for_hash.p.bin
else
	tail -c +17 $(BIN_DIR)/ram_3.p.bin > $(BIN_DIR)/ram_3_for_hash.p.bin
endif
	python $(HASH_PY) $(BIN_DIR)/ram_3_for_hash.p.bin
	cp output.bin hash_sum_3.bin
endif		

	$(PAD) 44k 0xFF $(BIN_DIR)/ram_1.p.bin
	cat $(BIN_DIR)/ram_1.p.bin > $(BIN_DIR)/$(RAMALL_BIN)
	chmod 777 $(BIN_DIR)/$(RAMALL_BIN)
ifeq ($(SECURE_BOOT),1)
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(ED25519) sign hash_sum_2.bin keypair.json; \
	fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(TAIL) -c 64 hash_sum_2.bin > signature_ram_2;\
	fi
else
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		mv signature signature_ram_2; \
	fi
endif
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		python $(REHEADER_PY) $(BIN_DIR)/ram_2.p.bin; \
		python $(REHEADER_PY) $(BIN_DIR)/ram_2.ns.bin; \
		cat signature_ram_2 >> $(BIN_DIR)/ram_2.p.bin; \
		cat signature_ram_2 >> $(BIN_DIR)/ram_2.ns.bin; \
		chmod 777 $(BIN_DIR)/ram_2.p.bin; \
	fi
endif
	cat $(BIN_DIR)/ram_2.p.bin >> $(BIN_DIR)/$(RAMALL_BIN)
ifeq ($(SECURE_BOOT),1)
	if [ -s $(BIN_DIR)/sdram.bin ]; then \
		$(ED25519) sign hash_sum_3.bin keypair.json; \
	fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	@if [ -f $(BIN_DIR)/sdram.bin ]; then \
		$(TAIL) -c 64 hash_sum_3.bin > signature_ram_3;\
	fi
else
	@if [ -f $(BIN_DIR)/sdram.bin ]; then \
		mv signature signature_ram_3; \
	fi
endif
	@if [ -s $(BIN_DIR)/sdram.bin ]; then \
		python $(REHEADER_PY) $(BIN_DIR)/ram_3.p.bin; \
		cat signature_ram_3 >> $(BIN_DIR)/ram_3.p.bin; \
		chmod 777 $(BIN_DIR)/ram_3.p.bin; \
		cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(RAMALL_BIN);\
	fi
else
	if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(RAMALL_BIN); fi
endif
# OTA
	cat $(BIN_DIR)/ram_2.ns.bin > $(BIN_DIR)/$(OTA_BIN)
	chmod 777 $(BIN_DIR)/$(OTA_BIN)
	if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(OTA_BIN); fi
	$(CHKSUM) $(BIN_DIR)/$(OTA_BIN) || true
	rm $(BIN_DIR)/ram_*.p.bin $(BIN_DIR)/ram_*.ns.bin

# Generate build info
# -------------------------------------------------------------------	

.PHONY: build_info
build_info:
	@echo \#define RTL_FW_COMPILE_TIME RTL8195AFW_COMPILE_TIME\ > .ver
	@echo \#define RTL_FW_COMPILE_DATE RTL8195AFW_COMPILE_DATE\ >> .ver
	@echo \#define UTS_VERSION \"`date +%Y/%m/%d-%T`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_TIME \"`date +%Y/%m/%d-%T`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_DATE \"`date +%Y%m%d`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_BY \"`id -u -n`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_HOST \"`$(HOSTNAME_APP)`\" >> .ver
	@if [ -x /bin/dnsdomainname ]; then \
		echo \#define RTL8195AFW_COMPILE_DOMAIN \"`dnsdomainname`\"; \
	elif [ -x /bin/domainname ]; then \
		echo \#define RTL8195AFW_COMPILE_DOMAIN \"`domainname`\"; \
	else \
		echo \#define RTL8195AFW_COMPILE_DOMAIN ; \
	fi >> .ver

	@echo \#define RTL8195AFW_COMPILER \"gcc `$(CC) $(CFLAGS) -dumpversion | tr --delete '\r'`\" >> .ver
	@mv -f .ver ../inc/$@.h


.PHONY: prerequirement
prerequirement:
	@echo ===========================================================
	@echo Build $(TARGET)
	@echo ===========================================================
	mkdir -p $(OBJ_DIR)
	mkdir -p $(BIN_DIR)
	cp ../../../component/soc/realtek/8195a/misc/bsp/image/ram_1.r.bin $(OBJ_DIR)/ram_1.r.bin
	chmod 777 $(OBJ_DIR)/ram_1.r.bin
	$(OBJCOPY) --rename-section .data=.loader.data,contents,alloc,load,readonly,data -I binary -O elf32-littlearm -B arm $(OBJ_DIR)/ram_1.r.bin $(OBJ_DIR)/ram_1.r.o 

$(SRC_O): %.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(OBJ_DIR)/$(notdir $(patsubst %.o,%.d,$@))
	cp $@ $(OBJ_DIR)/$(notdir $@)
	chmod 777 $(OBJ_DIR)/$(notdir $@)

$(DRAM_O): %.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(OBJCOPY) --prefix-alloc-sections .sdram $@
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(OBJ_DIR)/$(notdir $(patsubst %.o,%.d,$@))
	cp $@ $(OBJ_DIR)/$(notdir $@)
	chmod 777 $(OBJ_DIR)/$(notdir $@)

-include $(DEPENDENCY_LIST)

# Generate build info
# -------------------------------------------------------------------	
#ifeq (setup,$(firstword $(MAKECMDGOALS)))
#  # use the rest as arguments for "run"
#  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#  # ...and turn them into do-nothing targets
#  $(eval $(RUN_ARGS):;@:)
#endif
.PHONY: setup
setup:
	@echo "----------------"
	@echo Setup $(GDB_SERVER)
	@echo "----------------"
ifeq ($(GDB_SERVER), openocd)
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_debug_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_ramdebug_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_flash_write_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
else
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_debug_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_ramdebug_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_flash_write_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
endif

.PHONY: flashburn
flashburn:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
endif

	# manipulate ram_all.bin to no image1 sig (0x88167923)
	head -c 52 $(BIN_DIR)/ram_all.bin > $(BIN_DIR)/ram_all.ns.bin
	echo -n -e '\xFF\xFF\xFF\xFF' >> $(BIN_DIR)/ram_all.ns.bin
	#printf '%b' '\xFF\xFF\xFF\xFF'  >> $(BIN_DIR)/ram_all.ns.bin
	tail -c +57 $(BIN_DIR)/ram_all.bin >> $(BIN_DIR)/ram_all.ns.bin

	cp	$(FLASH_TOOLDIR)/target_NORMALB.axf $(FLASH_TOOLDIR)/target_NORMAL.axf
	chmod 777 $(FLASH_TOOLDIR)/target_NORMAL.axf
	chmod +rx $(FLASH_TOOLDIR)/SetupGDB_NORMAL.sh
	$(FLASH_TOOLDIR)/SetupGDB_NORMAL.sh
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
	rm $(BIN_DIR)/ram_*.ns.bin
	
.PHONY: debug
debug:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_debug.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
	cmd /c start $(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
else
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
endif

.PHONY: ramdebug
ramdebug:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
	cmd /c start $(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt	
else
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt	
endif

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -f $(SRC_O) $(DRAM_O)
	rm -f $(patsubst %.o,%.d,$(SRC_O)) $(patsubst %.o,%.d,$(DRAM_O))

