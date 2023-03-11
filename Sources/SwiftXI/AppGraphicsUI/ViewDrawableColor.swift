import Foundation

extension Color._Resolved: RBColorConvertible {
    func toSRGBColor() -> RBColor{
        return .init(red: linearRed.sRGBFromLinear, green: linearGreen.sRGBFromLinear, blue: linearBlue.sRGBFromLinear, opacity: opacity)
    }
}
extension Color.DisplayP3: RBColorConvertible{
    func toSRGBColor() -> RBColor{
        return .init(red: red, green: green, blue: blue, opacity: opacity)
    }
}
extension Color: RBColorConvertible {
    public func toSRGBColor() -> RBColor{
        return provider.toSRGBColor()
    } 
}
extension SystemColorType: RBColorConvertible {
    func toSRGBColor() -> RBColor {
        typealias _Resolved = Color._Resolved
        switch self {
        case .clear: return NSColor.clear.toSRGBColor()
        case .black: return NSColor.black.toSRGBColor()
        case .white: return NSColor.white.toSRGBColor()

        case .gray: return _Resolved.gray.toSRGBColor()
        case .red: return _Resolved.red.toSRGBColor()
        case .green: return _Resolved.green.toSRGBColor()
        case .blue: return _Resolved.blue.toSRGBColor()
        case .orange: return _Resolved.orange.toSRGBColor()
        case .yellow: return _Resolved.yellow.toSRGBColor()
        case .pink: return _Resolved.pink.toSRGBColor()
        case .purple: return _Resolved.purple.toSRGBColor()
        case .primary: return _Resolved.primary.toSRGBColor()
        case .secondary: return _Resolved.secondary.toSRGBColor()
        case .accentColor: return _Resolved.accentColor.toSRGBColor()
        }
    }
}
extension Color {
    // func toRGBLinearColor() -> Color {
    //     if type(of: self.provider) is ColorBox<_Resolved>.Type {
    //         return self
    //     }
    //     return self
    // }
    // func set() {
    //     let rgb = Color.red.toRGBLinearColor()
    //     Context.current?.setSource(color: (red: rgb.linearRed, green: 0.4, blue: 0.5))
    // }
}
