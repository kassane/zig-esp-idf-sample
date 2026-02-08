# ──────────────────────────────────────────────────────────────────────────────
# HELPER to run zig cli (build - translate-c - fmt - ...)
# ──────────────────────────────────────────────────────────────────────────────
function(zig_run)
    cmake_parse_arguments(PARSE_ARGV 0 ARG
        "VERBATIM"
        "WORKING_DIRECTORY;RESULT_VARIABLE;OUTPUT_VARIABLE;ERROR_VARIABLE;OUTPUT_FILE"
        "COMMAND"
    )
    if(NOT ARG_COMMAND)
        message(FATAL_ERROR "zig_run: COMMAND list is required")
    endif()
    if(NOT DEFINED ARG_WORKING_DIRECTORY)
        set(ARG_WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    endif()
    set(extra_args)
    if(ARG_VERBATIM)
        list(APPEND extra_args VERBATIM)
    endif()
    if(ARG_OUTPUT_FILE)
        list(APPEND extra_args OUTPUT_FILE "${ARG_OUTPUT_FILE}")
    endif()
    execute_process(
        COMMAND "${ZIG_BIN}" ${ARG_COMMAND}
        WORKING_DIRECTORY "${ARG_WORKING_DIRECTORY}"
        RESULT_VARIABLE result
        OUTPUT_VARIABLE output
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
        ${extra_args}
    )
    # Propagate results to parent scope if requested
    if(DEFINED ARG_RESULT_VARIABLE)
        set(${ARG_RESULT_VARIABLE} ${result} PARENT_SCOPE)
    endif()
    if(DEFINED ARG_OUTPUT_VARIABLE)
        set(${ARG_OUTPUT_VARIABLE} "${output}" PARENT_SCOPE)
    endif()
    if(DEFINED ARG_ERROR_VARIABLE)
        set(${ARG_ERROR_VARIABLE} "${error}" PARENT_SCOPE)
    endif()
    if(NOT result EQUAL 0)
        message(FATAL_ERROR "Zig command failed (code ${result}):\n"
            "  ${ZIG_BIN} ${ARG_COMMAND}\n"
            "--- stdout ---\n${output}\n"
            "--- stderr ---\n${error}")
    endif()
endfunction()
