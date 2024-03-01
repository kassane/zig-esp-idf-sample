idf_component_register(SRCS "main.c"
    INCLUDE_DIRS ".")
set(include_dirs $<TARGET_PROPERTY:${COMPONENT_LIB},INCLUDE_DIRECTORIES> ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})

add_custom_target(zig_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    zig build
    --build-file ${CMAKE_CURRENT_SOURCE_DIR}/build.zig
    -Doptimize=ReleaseSmall
    -Dtarget=riscv32-freestanding-none
    -Dcpu=generic_rv32+m+c
    --cache-dir ${CMAKE_BINARY_DIR}/zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libzig.a
    VERBATIM)

add_prebuilt_library(zig ${CMAKE_CURRENT_BINARY_DIR}/lib/libzig.a)
add_dependencies(zig zig_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libzig.a)
