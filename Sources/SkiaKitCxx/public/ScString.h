#pragma once
#include "ScTypes.h"
#include "ScValue.h"

class SkString;
namespace Swift{
    class String;
}

template<>
struct ScValueLimit<SkString>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 8;
};

class ScString: public ScValueN<SkString, ScValueLimit<SkString>::Size, ScValueLimit<SkString>::Align>{
    public:
    ScString();
    ScString(const ScString&);
    ScString(const SkString&);
    ScString& operator=(const ScString&);
    
    explicit ScString(const char text[]);
    
    void getData(char **ptr) const;
    const char *data() const;
    size_t size() const;

    ~ScString();
};
