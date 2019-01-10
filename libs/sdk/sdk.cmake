add_library(wmboot STATIC
    ${SDK}/Platform/Boot/gcc/startup_ARMCM3.S
    ${SDK}/Platform/Boot/gcc/misc.c
    ${SDK}/Platform/Boot/gcc/retarget_gcc.c
)
target_include_directories(wmboot
    PRIVATE
        ${SDK}/Platform/Boot/gcc/
        ${SDK}/Include
        ${SDK}/Include/OS
        ${SDK}/Platform/inc
)

add_library(wmmain STATIC
    ${SDK}/Platform/Sys/wm_main.c
    ${SDK}/Platform/Sys/tls_sys.c
    ${SDK}/Platform/Common/mem/wm_mem.c
    ${SDK}/Platform/Common/Params/wm_param.c
    ${SDK}/Platform/Common/utils/utils.c
    ${SDK}/Platform/Drivers/internalflash/wm_internal_fls.c
    ${SDK}/Src/App/oneshotconfig/wm_wifi_oneshot.c
)
target_include_directories(wmmain
    PRIVATE
        ${SDK}/Include
        ${SDK}/Include/OS
        ${SDK}/Include/Driver
        ${SDK}/Include/Platform
        ${SDK}/Include/WiFi
        ${SDK}/Include/App
        ${SDK}/Include/Net
        ${SDK}/Platform/Sys
        ${SDK}/Platform/Boot/gcc/
        ${SDK}/Platform/inc
)
target_link_libraries(wmmain
    PRIVATE
        wmrtos
        wmssl
        wmcrypto
)

add_library(wmrtos STATIC
    ${SDK}/Src/OS/RTOS/wm_osal_rtos.c
    
    ${SDK}/Src/OS/RTOS/ports/port_m3_gcc.c
    
    ${SDK}/Src/OS/RTOS/source/croutine.c
    ${SDK}/Src/OS/RTOS/source/heap_2.c
    ${SDK}/Src/OS/RTOS/source/heap_3.c
    ${SDK}/Src/OS/RTOS/source/list.c
    ${SDK}/Src/OS/RTOS/source/queue.c
    ${SDK}/Src/OS/RTOS/source/rtostimers.c
    ${SDK}/Src/OS/RTOS/source/tasks.c
)
target_include_directories(wmrtos
    PUBLIC
        ${SDK}/Src/OS/RTOS/include
    PRIVATE
        ${SDK}/Include/
        ${SDK}/Include/OS
        ${SDK}/Include/Driver
        ${SDK}/Include/Platform
        
)
target_link_libraries(wmrtos
    PRIVATE
        wmlwip
)

add_library(wmssl STATIC
    ${SDK}/Src/App/matrixssl/psk.c
)

target_include_directories(wmssl
    PUBLIC
        ${SDK}/Src/App/matrixssl
    PRIVATE
        ${SDK}/Include/
        ${SDK}/Include/Platform
        ${SDK}/Include/OS
        ${SDK}/Platform/inc

        ${SDK}/Platform/Common/crypto
        ${SDK}/Platform/Common/crypto/digest
        ${SDK}/Platform/Common/crypto/math
        ${SDK}/Platform/Common/crypto/symmetric
)

add_library(wlan INTERFACE)
target_link_libraries(wlan INTERFACE ${SDK}/Lib/GNU/wlan.a)

add_library(wmcrypto STATIC
    ${SDK}/Platform/Common/crypto/wm_crypto_hard.c
)
target_include_directories(wmcrypto
    PUBLIC      
        ${SDK}/Platform/Common/crypto
        ${SDK}/Platform/Common/crypto/digest
        ${SDK}/Platform/Common/crypto/math
        ${SDK}/Platform/Common/crypto/symmetric
    PRIVATE
        ${SDK}/Include/
        ${SDK}/Include/Driver
        ${SDK}/Include/Platform
        ${SDK}/Include/OS
        ${SDK}/Platform/Boot/gcc/
        ${SDK}/Platform/Inc
)
target_link_libraries(wmcrypto
    PUBLIC
        wmssl
)

add_library(wmdriver STATIC
    ${SDK}/Platform/Drivers/irq/wm_irq.c
    ${SDK}/Platform/Drivers/gpio/wm_gpio_afsel.c
    ${SDK}/Platform/Drivers/pmu/wm_pmu.c
    ${SDK}/Platform/Drivers/pwm/wm_pwm.c
    ${SDK}/Platform/Drivers/i2s/wm_i2s.c
    ${SDK}/Platform/Drivers/rtc/wm_rtc.c
    ${SDK}/Platform/Drivers/i2c/wm_i2c.c
    ${SDK}/Platform/Drivers/spi/wm_hostspi.c
    ${SDK}/Platform/Drivers/flash/wm_fls.c
    ${SDK}/Platform/Drivers/flash/wm_fls_gd25qxx.c
    ${SDK}/Platform/Drivers/cpu/wm_cpu.c
    ${SDK}/Platform/Drivers/watchdog/wm_watchdog.c
    ${SDK}/Platform/Drivers/efuse/wm_efuse.c
    ${SDK}/Platform/Drivers/io/wm_io.c
    ${SDK}/Platform/Drivers/dma/wm_dma.c
)
target_include_directories(wmdriver
    PUBLIC      
        ${SDK}/Include/Driver
    PRIVATE
        ${SDK}/Include/
        ${SDK}/Include/Platform
        ${SDK}/Include/OS
        ${SDK}/Include/WiFi
        ${SDK}/Platform/Boot/gcc/
        ${SDK}/Platform/Inc
)
target_link_libraries(wmdriver
    PRIVATE
        wmcrypto
)