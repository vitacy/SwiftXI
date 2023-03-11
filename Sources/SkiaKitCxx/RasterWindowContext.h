#ifndef RasterWindowContext_DEFINED
#define RasterWindowContext_DEFINED

#include "SkWindowContext.h"

namespace SC {

class RasterWindowContext : public WindowContext {
public:
    RasterWindowContext(const DisplayParams& params) : WindowContext(params) {}

protected:
    bool isGpuContext() override { return false; }
};

}   

#endif
