
open class NSFont: NSObject {
    let _internal: ScFont
    init(_ font: ScFont) {
        _internal = font
    }
    public convenience init?(name fontName: String, size fontSize: CGFloat) {
        let font = ScFont.init(fontName.toSkString(), fontSize)

        guard font.isValid() else{
            return nil
        }
        self.init(font)
    }
    public var fontName: String {
        //swift not works for this call result is a struct
        //call static func
        return ScFont.getFontName(_internal).toString()
    }
    public var familyName: String? {
        return ScFont.getFamilyName(_internal).toString()
    }
    public var pointSize: CGFloat {
        return CGFloat(_internal.pointSize())
    }
    public class func systemFont(ofSize fontSize: CGFloat) -> NSFont {
        return .init(name: "", size: fontSize)!
    }
    public class func boldSystemFont(ofSize fontSize: CGFloat) -> NSFont {
        return .systemFont(ofSize: fontSize)
    }
    public class var systemFontSize: CGFloat {
        return 20.0
    }
    public override var description: String {
        return "\(familyName ?? "") \(pointSize) \(fontName)"
    }
    public func bold() -> NSFont{
        return self
    }
    public func italic() -> NSFont{
        return self
    }
    var lineHeight: CGFloat{
        return CGFloat(_internal.lineHeight())
    }
    public var ascender: CGFloat { 
        return -CGFloat(_internal.ascender())
    }
    func unichars(_ unichars: [SkUnichar], toGlyphs glyphs: inout [SkGlyphID]){
        _internal.unicharsToGlyphs(unichars, Int32(unichars.count), &glyphs) 
    }
    func layoutGlyphs(_ glyphs: [SkGlyphID], widths: inout [SkScalar], paint: UnsafePointer<ScPaint>? = nil){
        _internal.layoutGlyphs(glyphs, Int32(glyphs.count), &widths, nil, paint)
    }
    func layoutUnichar(_ c: SkUnichar, glyph: inout SkGlyphID, width: inout SkScalar, paint: UnsafePointer<ScPaint>? = nil){
        var c=c
        _internal.unicharsToGlyphs(&c, 1, &glyph)
        _internal.layoutGlyphs(&glyph, 1, &width, nil, paint)
    }
    func fallbackSystemFont(for c: SkUnichar) -> NSFont?{
        var font = ScFont.init()
        _internal.fallbackSystemFont(c, &font)
        return .init(font)
    }
}
public class NSFontManager: NSObject {
    public static let shared = NSFontManager.init()
    public var availableFonts: [String] {
        return NSFontManager.shared.availableFontsImpl
    }
    public var availableFontFamilies: [String] {
        return NSFontManager.shared.availableFontFamiliesImpl
    }
}

extension NSFont{
    public struct Weight : Hashable, Equatable {
        let value: CGFloat
        init(_ v: CGFloat){
            value = v
        }

        public static let ultraLight: Weight = .init(-0.8)
        public static let thin: Weight = .init(-0.6)
        public static let light: Weight = .init(-0.4)
        public static let regular: Weight = .init(0)
        public static let medium: Weight = .init(0.23)
        public static let semibold: Weight = .init(0.3)
        public static let bold: Weight = .init(0.4)
        public static let heavy: Weight = .init(0.56)
        public static let black: Weight = .init(0.62)
    }
    public func withWeight(_ weight: Weight) -> NSFont{
        return self
    }
}