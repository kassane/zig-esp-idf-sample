/* Redirect wrapper — fixes Windows mixed-separator translate-c issue (issue #50).
 *
 * On Windows, clang joins include dirs with '\' when building resolved paths.
 * Having both `-I"include"` and `-I"include/freertos"` produces two different
 * path strings for the same physical file:
 *   include\freertos/portmacro.h  (via "freertos/portmacro.h")
 *   include/freertos\portmacro.h  (via "portmacro.h")
 * #pragma once fails because these look like different files to clang's VFS.
 *
 * Fix: redirect all "freertos/portmacro.h" (prefixed) includes through this
 * single wrapper. Angle-bracket include avoids same-dir lookup, finding the
 * real portmacro.h via -I"portable/ARCH/include/freertos" as the sole path.
 */
#pragma once
#include <portmacro.h>
