
function(add_hlsl_header input shader type dependentSources)

	find_program(ATB_D3D11_FXC fxc
	PATHS  "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;InstallationFolder]/bin/x86"
               "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;InstallationFolder]/bin/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;ProductVersion].0/x86"
               "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v8.1;InstallationFolder]/bin/x86"
               "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v8.0;InstallationFolder]/bin/x86"
               "$ENV{WindowsSdkDir}bin/x86")

	if (NOT ATB_D3D11_FXC)
		message(SEND_ERROR "No DirectX Effects Compiler (fxc.exe) for Direct3D 11 available.")
	endif()

	get_filename_component(name ${input} NAME_WE)
	get_filename_component(absInput ${input}
			ABSOLUTE ${CMAKE_CURRENT_SOURCE_DIR})

	set(output "${name}_${shader}.h")
	get_filename_component(absOutput ${output}
			ABSOLUTE ${CMAKE_CURRENT_BINARY_DIR})

	add_custom_command(
		OUTPUT ${absOutput}
		COMMAND
			${ATB_D3D11_FXC}
			/T ${type} /E ${shader}
			/Fh ${output} ${absInput}
		MAIN_DEPENDENCY ${absInput})

	set_property(SOURCE ${dependentSources} ${ARGN}
			APPEND PROPERTY OBJECT_DEPENDS ${absOutput})

endfunction()

# Workaround to keep VisualStudio from compiling an HLSL file
function(ignore_hlsl input)

	get_filename_component(absInput ${input}
			ABSOLUTE ${CMAKE_CURRENT_SOURCE_DIR})

	add_custom_command(
		OUTPUT Dummy
		COMMAND ${CMAKE_COMMAND} -E touch Dummy
		MAIN_DEPENDENCY "${absInput}")

endfunction()

