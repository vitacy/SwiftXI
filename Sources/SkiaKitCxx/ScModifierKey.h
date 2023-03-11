#ifndef SC_modifierkey_defined
#define SC_modifierkey_defined

#include "include/private/SkBitmaskEnum.h"
#include "ScAppEvent.h"

namespace sknonstd {
template <> struct is_bitmask_enum<SC::ModifierKey> : std::true_type {};
}  


#endif  
