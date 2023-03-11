import Foundation

public struct Color: Hashable, CustomStringConvertible {
    var provider: AnyColorBox
    public var description: String {
        return "\(provider)"
    }
}

extension CGColor{
    public convenience init(_ color: Color){
        self.init(color.provider)
    }
}

extension Color {
    public enum RGBColorSpace: Int8, Hashable {
        case sRGB
        case sRGBLinear
        case displayP3
    }
    struct _Resolved: Hashable, CustomStringConvertible {
        let linearRed: Double
        let linearGreen: Double
        let linearBlue: Double
        let opacity: Double

        init(linearRed: Double, green: Double, blue: Double, opacity: Double) {
            self.linearRed = linearRed
            linearGreen = green
            linearBlue = blue
            self.opacity = opacity
        }
        init(sRGBRed: Double, green: Double, blue: Double, opacity: Double) {
            self.init(linearRed: sRGBRed.sRGBToLinear, green: green.sRGBToLinear, blue: blue.sRGBToLinear, opacity: opacity)
        }
        var description: String {
            return "#\(linearRed.inearHexString)\(linearGreen.inearHexString)\(linearBlue.inearHexString)\(opacity.hexString)"
        }
    }
    struct DisplayP3: Hashable{
        let red: Double
        let green: Double
        let blue: Double
        let opacity: Double
    }
    init(_ provider: AnyColorBox) {
        self.provider = provider
    }
    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, red: Double, green: Double, blue: Double, opacity: Double = 1) {
        switch colorSpace {
        case .sRGB:
            self.provider = ColorBox.init(_Resolved(sRGBRed: red, green: green, blue: blue, opacity: opacity))
        case .sRGBLinear:
            self.provider = ColorBox.init(_Resolved(linearRed: red, green: green, blue: blue, opacity: opacity))
        case .displayP3:
            self.provider = ColorBox.init(DisplayP3(red: red, green: green, blue: blue, opacity: opacity))
        }
    }
    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) {
        self.init(colorSpace, red: white, green: white, blue: white, opacity: opacity)
    }
    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
        let rgb = Color.hsbToRGB(hue: hue, saturation: saturation, brightness: brightness)
        self.init(.sRGB, red: rgb.red, green: rgb.green, blue: rgb.blue, opacity: opacity)
    }
}
extension Double {
    fileprivate var hexString: String {
        return String(format: "%02X", Int((self * 255).rounded()))
    }
    fileprivate var inearHexString: String {
        return self.sRGBFromLinear.hexString
    }
    fileprivate var percentString: String {
        return "\(Int((self * 100).rounded()))%"
    }
    
    //https://www.color.org/chardata/rgb/srgb.xalter
    //Color component transfer function:
    //C'=12.92 C 	C ≤ 0.0031308
    //C'=1.055 C1/2.4-0.055 	C > 0.0031308 
    var sRGBToLinear: Double {
        var value = self
        if value <= 0.04045 {
            value /= 12.92
        } else {
            value = pow((value + 0.055) / 1.055, 2.4)
        }
        return value
    }
    var sRGBFromLinear: Double {
        var value = self
        if value <= 0.0031308 {
            value *= 12.92
        } else {
            value = 1.055 * pow(value, 1.0 / 2.4) - 0.055
        }
        return value
    }
}
extension Color: View {
    public typealias Body = _ShapeView<Rectangle, Self>
}

extension Color : ShapeStyle {
}
enum SystemColorType: String {
    case clear
    case black
    case white
    case gray
    case red
    case green
    case blue
    case orange
    case yellow
    case pink
    case purple
    case primary
    case secondary
    case accentColor
}
extension Color {
    init(_ color: SystemColorType) {
        self.provider = ColorBox.init(color)
    }
    public static let clear = Color(SystemColorType.clear)
    public static let black = Color(SystemColorType.black)
    public static let white = Color(SystemColorType.white)
    public static let gray = Color(SystemColorType.gray)
    public static let red = Color(SystemColorType.red)
    public static let green = Color(SystemColorType.green)
    public static let blue = Color(SystemColorType.blue)
    public static let orange = Color(SystemColorType.orange)
    public static let yellow = Color(SystemColorType.yellow)
    public static let pink = Color(SystemColorType.pink)
    public static let purple = Color(SystemColorType.purple)
    public static let primary = Color(SystemColorType.primary)
    public static let secondary = Color(SystemColorType.secondary)
    public static let accentColor = Color(SystemColorType.accentColor)
}

// extension Color {
//     public init(_ name: String, bundle: Bundle? = nil)
// }

extension Color {
    final class OpacityColor<Content: RBColorConvertible>: AnyColorBox {
        let opacity: Double
        var base: Content
        init(_ c: Content, opacity: Double) {
            self.base = c
            self.opacity = opacity
            super.init()
        }
        override var description: String {
            return "\(opacity.percentString) \(base)"
        }
        override func toSRGBColor() -> RBColor{
            var color = self.base.toSRGBColor()
            color.opacity *= opacity
            return color
        }
    }
    public func opacity(_ opacity: Double) -> Color {
        return .init(OpacityColor.init(self, opacity: opacity))
    }
}

extension Color {
    public var cgColor: CGColor? {
        return nil
    }
    public init(_ cgColor: CGColor) {
        self.provider = ColorBox.init(cgColor)
    }
}
extension Color._Resolved {
    static var gray: Color{
        return .init(red: 0.556863, green: 0.556863, blue: 0.576471, opacity: 1)
    }
    static var red: Color{
        return .init(red: 1, green: 0.231373, blue: 0.188235, opacity: 1)
    }
    static var green: Color{
        return .init(red: 0.156863, green: 0.803922, blue: 0.254902, opacity: 1)
    }
    static var blue: Color{
        return .init(red: 0, green: 0.478431, blue: 1, opacity: 1)
    }
    static var orange: Color{
        return .init(red: 1, green: 0.584314, blue: 0, opacity: 1)
    }
    static var yellow: Color{
        return .init(red: 1, green: 0.8, blue: 0, opacity: 1)
    }
    static var purple: Color{
        return .init(red: 0.686275, green: 0.321569, blue: 0.870588, opacity: 1)
    }
    static var pink: Color {
        return .init(red: 1, green: 0.176471, blue: 0.333333, opacity: 1)
    }
    static var primary: Color {
        return .init(red: 0, green: 0, blue: 0, opacity: 0.847059)
    }
    static var secondary: Color {
        return .init(red: 0, green: 0, blue: 0, opacity: 0.498039)
    }
    static var accentColor: Color {
        return .init(red: 0, green: 0.478431, blue: 1, opacity: 1)
    }
}
extension Color {
    static func hsbToRGB(hue: Double, saturation: Double, brightness: Double) -> (red: Double, green: Double, blue: Double) {
        // Based on:
        // http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0

        let i = floor(hue * 6)
        let f = hue * 6 - i
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)

        switch i.truncatingRemainder(dividingBy: 6) {
        case 0:
            red = brightness
            green = t
            blue = p
        case 1:
            red = q
            green = brightness
            blue = p
        case 2:
            red = p
            green = brightness
            blue = t
        case 3:
            red = p
            green = q
            blue = brightness
        case 4:
            red = t
            green = p
            blue = brightness
        case 5:
            red = brightness
            green = p
            blue = q
        default:
            break
        }

        return (red, green, blue)
    }
}
