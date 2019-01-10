set(NAME hello_world)

add_executable(${NAME}
    main.c
)

set(LINKER_SCRIPT ${SDK}/Tools/GNU/link_w600.ld)

set_property(TARGET ${NAME} APPEND PROPERTY LINK_FLAGS  "-Wl,-T ${LINKER_SCRIPT}")

target_link_libraries(${NAME}
    PRIVATE
        -Wl,--start-group
        wlan
        wmboot
        wmmain
        wmdriver
        wmrtos
        wmlwip
        wmssl
        wmcrypto
        -Wl,--end-group
)

target_include_directories(${NAME}
    PRIVATE
        ${SDK}/Include
        ${SDK}/Include/WiFi
        ${SDK}/Include/App
        ${SDK}/Include/OS
        ${SDK}/Include/Net
        ${SDK}/Include/Platform
)

target_generate_bin(${NAME})
target_make_image(${NAME})
target_flash(${NAME})