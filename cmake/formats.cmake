function(target_generate_hex TARGET)
	set(ELF_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET})
	set(HEX_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET}.hex)

	add_custom_command(OUTPUT ${HEX_FILE}
		COMMAND ${CMAKE_OBJCOPY} -O ihex ${ELF_FILE} ${HEX_FILE}
		DEPENDS ${ELF_FILE}
	)
	add_custom_target(${TARGET}.hex DEPENDS ${HEX_FILE})
endfunction()

function(target_generate_bin TARGET)
	set(ELF_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET})
	set(BIN_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET}.bin)

	add_custom_command(OUTPUT ${BIN_FILE}
		COMMAND ${CMAKE_OBJCOPY} --output-target=binary -S -g -x -X -R .sbss -R .bss -R .reginfo -R .stack ${ELF_FILE} ${BIN_FILE}
		DEPENDS ${ELF_FILE}
	)
	add_custom_target(${TARGET}.bin DEPENDS ${BIN_FILE})
endfunction()