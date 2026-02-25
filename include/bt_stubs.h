/* bt_stubs.h — Static inline wrappers for BT macros that zig translate-c
 * cannot handle directly.
 *
 * Included by stubs.h AFTER bindings.h (which pulls in esp_bt.h).
 * The translate-c pipeline converts these into callable Zig functions
 * inside idf-sys.zig.
 */

#ifndef BT_STUBS_H
#define BT_STUBS_H

#ifndef CONFIG_IDF_TARGET_ESP32S2 /* No BT in ESP32-S2 */
#ifdef CONFIG_BT_ENABLED

/*
 * BT_CONTROLLER_INIT_CONFIG_DEFAULT() is a macro that expands to a
 * designated-initialiser struct literal — translate-c chokes on it.
 * Wrapping it in a static inline function lets the C preprocessor
 * expand the macro before translate-c sees the AST.
 */
static inline esp_bt_controller_config_t zig_bt_controller_default_cfg(void)
{
    esp_bt_controller_config_t cfg = BT_CONTROLLER_INIT_CONFIG_DEFAULT();
    return cfg;
}

#endif /* CONFIG_BT_ENABLED */
#endif /* !CONFIG_IDF_TARGET_ESP32S2 */

#endif /* BT_STUBS_H */
