function(target_make_image TARGET)
    set(BIN_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET}.bin)
    set(IMG_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET}.img)

    add_custom_command(OUTPUT ${IMG_FILE}
        COMMAND ${Python3_EXECUTABLE} ${SDK}/Tools/makeimg.py ${BIN_FILE} ${IMG_FILE} 0 0 ${SDK}/Bin/version.txt 90000 10100
        DEPENDS ${BIN_FILE}
    )
    add_custom_target(${TARGET}.img DEPENDS ${IMG_FILE})
endfunction()

function(target_flash TARGET)
    set(IMG_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET}.img)

    add_custom_target(${TARGET}.flash
        COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tools/upload.py ${AIR602_PORT} ${IMG_FILE}
        DEPENDS ${IMG_FILE}
        USES_TERMINAL
    )
endfunction()