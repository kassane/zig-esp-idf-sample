/* pthread_stubs.h — Minimal POSIX pthread declarations for zig translate-c.
 *
 * The system pthread.h (newlib) fails translate-c because it includes
 * <sys/types.h>, <time.h>, and <sched.h> — all of which are blocked by
 * header guards in stubs.h. This file provides the exact types and function
 * prototypes that ESP-IDF's FreeRTOS-backed pthread implementation exposes,
 * expressed in a form translate-c can digest without those dependencies.
 */

#ifndef PTHREAD_STUBS_H
#define PTHREAD_STUBS_H

#include <stddef.h>
#include <stdint.h>

/* ── Opaque handle types ──────────────────────────────────────────────────── */

typedef unsigned int pthread_t;
typedef unsigned int pthread_mutex_t;
typedef unsigned int pthread_cond_t;
typedef unsigned int pthread_key_t;

/* ── Attribute structs ───────────────────────────────────────────────────── */

typedef struct {
    int is_initialized;
    void *stackaddr;
    int stacksize;
    int contentionscope;
    int inheritsched;
    int schedpolicy;
    int sched_priority;   /* inline sched_param to avoid sched.h dependency */
    int detachstate;
} pthread_attr_t;

typedef struct {
    int is_initialized;
    int type;
    int recursive;
} pthread_mutexattr_t;

typedef struct {
    int is_initialized;
    unsigned long clock;
} pthread_condattr_t;

typedef struct {
    int is_initialized;
    int init_executed;
} pthread_once_t;

/* ── timespec (needed for timedlock / timedwait) ─────────────────────────── */

/* Define struct timespec once and mark all known system guards to prevent
   sys/_timespec.h from redefining it with an incompatible layout. */
#if !defined(_TIMESPEC_DEFINED) && !defined(_SYS__TIMESPEC_H_)
#define _TIMESPEC_DEFINED
#define _SYS__TIMESPEC_H_
struct timespec {
    long tv_sec;
    long tv_nsec;
};
#endif

/* ── Thread lifecycle ────────────────────────────────────────────────────── */

int  pthread_create(pthread_t *tid, const pthread_attr_t *attr,
                    void *(*start_routine)(void *), void *arg);
int  pthread_join(pthread_t thread, void **value_ptr);
int  pthread_detach(pthread_t thread);
void pthread_exit(void *value_ptr);
pthread_t pthread_self(void);
int  pthread_equal(pthread_t t1, pthread_t t2);
void pthread_yield(void);
int  pthread_once(pthread_once_t *once_control, void (*init_routine)(void));
int  pthread_cancel(pthread_t thread);
int  pthread_setcancelstate(int state, int *oldstate);
int  pthread_setcanceltype(int type, int *oldtype);
void pthread_testcancel(void);

/* ── Thread attributes ───────────────────────────────────────────────────── */

int pthread_attr_init(pthread_attr_t *attr);
int pthread_attr_destroy(pthread_attr_t *attr);
int pthread_attr_setstacksize(pthread_attr_t *attr, size_t stacksize);
int pthread_attr_getstacksize(const pthread_attr_t *attr, size_t *stacksize);
int pthread_attr_setdetachstate(pthread_attr_t *attr, int detachstate);
int pthread_attr_getdetachstate(const pthread_attr_t *attr, int *detachstate);

/* ── Mutex ───────────────────────────────────────────────────────────────── */

int pthread_mutexattr_init(pthread_mutexattr_t *attr);
int pthread_mutexattr_destroy(pthread_mutexattr_t *attr);
int pthread_mutexattr_gettype(const pthread_mutexattr_t *attr, int *kind);
int pthread_mutexattr_settype(pthread_mutexattr_t *attr, int kind);
int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
int pthread_mutex_destroy(pthread_mutex_t *mutex);
int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_trylock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);
int pthread_mutex_timedlock(pthread_mutex_t *mutex,
                            const struct timespec *timeout);

/* ── Condition variable ──────────────────────────────────────────────────── */

int pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *attr);
int pthread_cond_destroy(pthread_cond_t *cond);
int pthread_cond_signal(pthread_cond_t *cond);
int pthread_cond_broadcast(pthread_cond_t *cond);
int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
int pthread_cond_timedwait(pthread_cond_t *cond, pthread_mutex_t *mutex,
                           const struct timespec *abstime);

/* ── Thread-local storage (TLS) keys ─────────────────────────────────────── */

int   pthread_key_create(pthread_key_t *key, void (*destructor)(void *));
int   pthread_key_delete(pthread_key_t key);
int   pthread_setspecific(pthread_key_t key, const void *value);
void *pthread_getspecific(pthread_key_t key);

#endif /* PTHREAD_STUBS_H */
