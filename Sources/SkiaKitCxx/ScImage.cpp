#include "ScImage.h"
#include "SkiaCxxPrivate.h"

ScImage::ScImage(){

}
ScImage::ScImage(const ScImage& image){
    ref() = image.ref();
}
ScImage::~ScImage(){
    
}
ScImage::ScImage(const ScData& data){
    ref() = SkImage::MakeFromEncoded(data.ref());
}
bool ScImage::isValid() const{
    return (bool)ref();
}
SkScalar ScImage::width() const {
    return ref()->width();
}
SkScalar ScImage::height() const {
    return ref()->height();
}
ScBitmap::ScBitmap(){

}
ScBitmap::ScBitmap(const ScBitmap& image){
    ref() = image.ref();
}
ScBitmap::~ScBitmap(){

}
SkScalar ScBitmap::width() const {
    return ref().width();
}
SkScalar ScBitmap::height() const {
    return ref().height();
}
bool ScBitmap::installPixels(const ScImageInfo& info, void* pixels, size_t rowBytes, void (*releaseProc)(void* addr, void* context), void* context){
    return ref().installPixels(info.ref(), pixels, rowBytes, releaseProc, context);
}
void ScBitmap::setImmutable(){
    ref().setImmutable();
}
ScImageInfo::ScImageInfo(){}
ScImageInfo::ScImageInfo(const ScImageInfo&){}
ScImageInfo::~ScImageInfo(){}

ScImageInfo ScImageInfo::Make(int width, int height, ScColorType ct, ScAlphaType at){
    ScImageInfo info;
    info.ref() = SkImageInfo::Make(width, height, (SkColorType)ct, (SkAlphaType)at);
    return info;
}
ScData::ScData(){

}
ScData::ScData(const ScData& d){
    ref() = d.ref();
}
ScData::~ScData(){

}
ScData::ScData(const void* ptr, size_t length, ReleaseProc proc, void* ctx){
    ref() = SkData::MakeWithProc(ptr, length, proc, ctx);
}