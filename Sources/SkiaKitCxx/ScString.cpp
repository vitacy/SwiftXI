#include "ScString.h"
#include "SkiaCxxPrivate.h"

ScString::ScString(){

}
ScString::ScString(const ScString&v){
    ref() = v.ref();
}
ScString::ScString(const SkString& v){
    ref() = v;
}
ScString& ScString::operator=(const ScString& v){
    ref() = v.ref();
    return *this;
}
ScString::~ScString(){

}

ScString::ScString(const char text[]){
    ref() = SkString(text);
}
    
void ScString::getData(char **ptr) const{
    if (ptr != nullptr){
        *ptr = (char*)data();
    }
}
const char *ScString::data() const{
    return ref().data();
}
size_t ScString::size() const{
    return ref().size();
}