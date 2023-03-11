
public struct Font : Hashable, Equatable {
    let provider: AnyFontBox
    init(_ box: AnyFontBox = AnyFontBox()){
        provider = box
    }
}

class AnyFontBox: Hashable, Equatable, _ToNSFontProtocol{
    static func == (lhs: AnyFontBox, rhs: AnyFontBox) -> Bool{
        return lhs.isEqual(to: rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    func isEqual(to object: AnyFontBox) -> Bool{
        return type(of: self) == type(of: object)
    }
    func nsFont() -> NSFont{
        return Font.body.nsFont()
    }
}
class FontBox<T>: AnyFontBox where T: Hashable, T: Equatable, T: _ToNSFontProtocol {
    let base: T
    init(_ base: T){
        self.base = base
    }
    override func isEqual(to object: AnyFontBox) -> Bool{
        guard let rhs = object as? FontBox else{
            return false
        }
        return self.base == rhs.base
    }
    override func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }
    override func nsFont() -> NSFont{
        return base.nsFont()
    }
}
extension Font {
    struct NamedProvider: Hashable, Equatable{
        let name: String
        let size: CGFloat
        let textStyle: TextStyle?
    }
    public static func custom(_ name: String, size: CGFloat) -> Font{
        return .init(FontBox.init(NamedProvider.init(name: name, size: size, textStyle: .some(.body))))
    }
    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font{
        return .init(FontBox.init(NamedProvider.init(name: name, size: size, textStyle: textStyle)))
    }
    public static func custom(_ name: String, fixedSize: CGFloat) -> Font{
        return .init(FontBox.init(NamedProvider.init(name: name, size: fixedSize, textStyle: nil)))
    }

    struct PlatformFontProvider: Hashable, Equatable{
        let font: NSFont
    }
    public init(_ font: NSFont){
        self.init(FontBox.init(PlatformFontProvider.init(font: font)))
    }
}

extension Font {
    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font{
        return .init(FontBox.init(SystemProvider.init(size: size, weight: weight, design: design)))
    }
    struct SystemProvider: Hashable, Equatable{
        let size: CGFloat
        let weight: Weight
        let design: Design
    }
    public enum Design : Hashable, Equatable {
        case `default`
        case rounded
        case monospaced
    }
}
extension Font {
    public static let largeTitle: Font = .system(.largeTitle)
    public static let title: Font = .system(.title)
    public static let title2: Font = .system(.title2)
    public static let title3: Font = .system(.title3)
    public static let headline: Font = .system(.headline)
    public static let subheadline: Font = .system(.subheadline)
    public static let body: Font = .system(.body)
    public static let callout: Font = .system(.callout)
    public static let footnote: Font = .system(.footnote)
    public static let caption: Font = .system(.caption)
    public static let caption2: Font = .system(.caption2)

    public static func system(_ style: Font.TextStyle, design: Font.Design = .default) -> Font{
        return .init(FontBox.init(TextStyleProvider.init(style: style, design: design, weight: nil)))
    }
    
    struct TextStyleProvider: Hashable, Equatable{
        let style: TextStyle
        let design: Design
        let weight: Weight?
    }

    public enum TextStyle : CaseIterable, Equatable, Hashable {
        case largeTitle
        case title
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption
        case caption2
    }
}

extension Font {
    public typealias Weight = NSFont.Weight
    struct ModifierProvider<T>: Hashable, Equatable where T: Hashable, T: Equatable, T: _FontModifierProtocol {
        let base: Font
        let modifier: T
    }
    struct ItalicModifier: Hashable, Equatable{
    }
    struct BoldModifier: Hashable, Equatable{
    }
    struct WeightModifier: Hashable, Equatable{
        let weight: Weight
    }
    struct LeadingModifier: Hashable, Equatable{
        let leading: Leading
    }
    public func italic() -> Font{
        return .init(FontBox.init(ModifierProvider.init(base: self, modifier: ItalicModifier())))
    }
    public func smallCaps() -> Font{
        return .init()
    }
    public func lowercaseSmallCaps() -> Font{
        return self
    }
    public func uppercaseSmallCaps() -> Font{
        return self
    }
    public func monospacedDigit() -> Font{
        return self
    }
    public func weight(_ weight: Font.Weight) -> Font{
        return .init(FontBox.init(ModifierProvider.init(base: self, modifier: WeightModifier.init(weight: weight))))
    }
    public func bold() -> Font{
        return .init(FontBox.init(ModifierProvider.init(base: self, modifier: BoldModifier())))
    }
    public func leading(_ leading: Font.Leading) -> Font{
        return .init(FontBox.init(ModifierProvider.init(base: self, modifier: LeadingModifier.init(leading: leading))))
    }

    public enum Leading: Hashable, Equatable {
        case standard
        case tight
        case loose
    }
}

protocol _FontModifierProtocol{
    func modifer(_ font: NSFont) -> NSFont
}
extension _FontModifierProtocol{
    func modifer(_ font: NSFont) -> NSFont{
        return font
    }
}
extension Font.BoldModifier: _FontModifierProtocol{
    func modifer(_ font: NSFont) -> NSFont{
        return font.bold()
    }
}
extension Font.ItalicModifier: _FontModifierProtocol{
    func modifer(_ font: NSFont) -> NSFont{
        return font.italic()
    }
}
extension Font.WeightModifier: _FontModifierProtocol{
    func modifer(_ font: NSFont) -> NSFont{
        return font.withWeight(weight)
    }
}
extension Font.LeadingModifier: _FontModifierProtocol{
}

protocol _ToNSFontProtocol{
    func nsFont() -> NSFont
}

extension Font{
    func nsFont() -> NSFont{
        return self.provider.nsFont()
    }
}

extension Font.NamedProvider: _ToNSFontProtocol{
    func nsFont() -> NSFont{
        if let f = NSFont.init(name: name, size: size){
            return f
        }
        return NSFont.systemFont(ofSize: size)
    }
}
extension Font.ModifierProvider: _ToNSFontProtocol{
    func nsFont() -> NSFont{
        return modifier.modifer(base.nsFont())
    }
}
extension Font.SystemProvider: _ToNSFontProtocol{
    func nsFont() -> NSFont{
        return NSFont.systemFont(ofSize: size)
    }
}
extension Font.PlatformFontProvider: _ToNSFontProtocol{
    func nsFont() -> NSFont{
        return font
    }
}
extension Font.TextStyleProvider: _ToNSFontProtocol{
    func nsFont() -> NSFont{
        var fontSize: CGFloat = 0.0
        var bold = false
        switch self.style{
        case .largeTitle: fontSize = 34.0
        case .title: fontSize = 28.0
        case .title2: fontSize = 22.0
        case .title3: fontSize = 20.0
        case .headline: fontSize = 17.0; bold = true
        case .subheadline: fontSize = 15.0
        case .body: fontSize = 17.0
        case .callout: fontSize = 16.0
        case .footnote: fontSize = 13.0
        case .caption: fontSize = 12.0
        case .caption2: fontSize = 11.0
        }
        if (bold){
            return .boldSystemFont(ofSize: fontSize)
        }
        return .systemFont(ofSize: fontSize)
    }
}