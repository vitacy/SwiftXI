#include "ScContext.h"
#include "SkiaCxxPrivate.h"

ScCanvas::ScCanvas(SkCanvas *c) {
    canvas = c;
}
void ScCanvas::save() const {
    canvas->save();
}
void ScCanvas::restore() const {
    canvas->restore();
}
void ScCanvas::draw(const ScPath &path, const ScPaint &paint) const {
    canvas->drawPath(path.ref(), paint.ref());
}
// void ScCanvas::drawGlyphs(int count, const SkGlyphID glyphs[], const ScPoint positions[], const ScPoint &origin, const ScFont& font, const ScPaint& paint) const{
//     canvas->drawGlyphs(count, glyphs, positions, origin, font.ref(), paint.ref());
// }
// // void ScCanvas::draw(const SkString& text, const ScFont& font, const SkPaint& paint) const{
// //     auto f=font.getFont();
// //     if (f == nullptr){
// //         return;
// //     }
// //     canvas->drawSimpleText(text.data(), text.size(),SkTextEncoding::kUTF8,0,0,*f,paint);
// // }
// void ScCanvas::drawImage(const ScBitmap &bitmap, const SkRect &rect) const{
//     drawImage(bitmap.asImage(), rect);
// }
// void ScCanvas::drawImage(const ScImage &image, const ScRect &rect) const{
//     drawImage(image.getImage(), rect);
// }
// void ScCanvas::concat(SkMatrix &matrix) const {
//     canvas->concat(matrix);
// }
// void ScCanvas::clipPath(const ScPath& path, bool antialiased) const{
//     canvas->clipPath(path.ref(), SkClipOp::kIntersect, antialiased);
// }
void ScPath::moveTo(SkScalar x, SkScalar y){
    ref().moveTo(x, y);
}
void ScPath::lineTo(SkScalar x, SkScalar y){
    ref().lineTo(x, y);
}
void ScPath::quadTo(const ScPoint& p1, const ScPoint& p2){
    ref().quadTo(p1.x(), p1.y(), p2.x(), p2.y());
}
void ScPath::cubicTo(const ScPoint& p1, const ScPoint& p2, const ScPoint& p3){
    ref().cubicTo(p1.x(), p1.y(), p2.x(), p2.y(), p3.x(), p3.y());
}
void ScPath::close(){
    ref().close();
}

void ScPaint::setColor(ScFloat r, ScFloat g, ScFloat b, ScFloat a){
    ref().setColor(SkColor4f{float(r), float(g), float(b), float(a)});
}
void ScPaint::setStroke(bool b){
    ref().setStroke(b);
}
void ScPaint::setAntiAlias(bool b){
    ref().setAntiAlias(b);
}
class ScContext::ScContextInternal{

};
ScContext::ScContext(){

}
ScContext::~ScContext(){
    canvas = nullptr;
}
ScContext::ScContext(const ScContext& c){
    canvas = c.canvas;
}
ScContext::ScContext(SkCanvas *c){
    canvas = c;
}

void ScContext::concatTransform(const float m[6]){
    SkMatrix matrix;
    matrix.setAffine(m);
    canvas->concat(matrix);
}
void ScContext::setTransform(const float m[6]){
    canvas->resetMatrix();
    concatTransform(m);
}
void ScContext::clipPath(const ScPath& path, bool antialiased) const{
    canvas->clipPath(path.ref(), SkClipOp::kIntersect, antialiased);
}

void ScContext::drawPath(const ScPath &path, const ScPaint &paint) const{
    canvas->drawPath(path.ref(), paint.ref());
}
void ScContext::drawGlyphs(int count, const SkGlyphID glyphs[], const ScPoint positions[], const ScPoint &origin, const ScFont& font, const ScPaint& paint) const{
    canvas->drawGlyphs(count, glyphs, (SkPoint*)positions, origin|ScSK, font.ref(), paint.ref());
}
void ScContext::drawImage(const ScImage &image, const ScRect &rect) const{
    canvas->drawImageRect(image.ref(), rect|ScSK, SkSamplingOptions(), nullptr);
}
void ScContext::drawImage(const ScBitmap &bitmap, const ScRect &rect) const{
    canvas->drawImageRect(bitmap.ref().asImage(), rect|ScSK, SkSamplingOptions(), nullptr);
}

void ScContext::save(){
    canvas->save();
}
void ScContext::restore(){
    canvas->restore();
}