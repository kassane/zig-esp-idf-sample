#pragma once
// CHIP SDK closure-control cluster structs are missing operator==(const T&) required
// by std::optional<T> comparison in GCC 14 C++23 mode.
// This header adds free-function operators via ADL so the types satisfy
// std::equality_comparable without touching managed_components sources.
// Applied via -include CMake file property to the specific failing TUs only.
#ifdef __cplusplus
#include "app/clusters/closure-control-server/closure-control-cluster-objects.h"

namespace chip {
namespace app {
namespace Clusters {
namespace ClosureControl {

inline bool operator==(const GenericOverallCurrentState & a, const GenericOverallCurrentState & b)
{
    return a.position == b.position && a.latch == b.latch &&
           a.speed == b.speed && a.secureState == b.secureState;
}

inline bool operator==(const GenericOverallTargetState & a, const GenericOverallTargetState & b)
{
    return a.position == b.position && a.latch == b.latch && a.speed == b.speed;
}

} // namespace ClosureControl
} // namespace Clusters
} // namespace app
} // namespace chip
#endif // __cplusplus
