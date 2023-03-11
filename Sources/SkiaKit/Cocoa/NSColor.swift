import Foundation

public typealias UIColor = NSColor
public typealias NSColor = CGColor
extension NSColor{
    convenience public init(srgbRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        self.init(RBColor.init(red: red, green: green, blue: blue, opacity: alpha))
    }
    convenience public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        self.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}

extension NSColor{
    func withAlphaComponent(_ alpha: CGFloat) -> NSColor{
        var color = toSRGBColor()
        color.opacity *= alpha
        return .init(color)
    }
    public var redComponent: CGFloat { 
        return toSRGBColor().red
    }

    public var greenComponent: CGFloat { 
        return toSRGBColor().green
    }

    public var blueComponent: CGFloat { 
        return toSRGBColor().blue
    }
    public var alphaComponent: CGFloat { 
        return toSRGBColor().opacity
    }
    public var cgColor: CGColor { 
        return self
     }
}
struct SRGBColorSpace: Hashable{
}

extension NSColor{
    public convenience init(_ color: RBColor){
        self.init(ColorBox.init(color))
    }
    public convenience init<T: RBColorConvertible>(convertible color: T){
        self.init(color.toSRGBColor())
    }
    
}
extension NSColor{
    public static var clear: NSColor {
        return .init(RBColor.init(red: 0, green: 0, blue: 0, opacity: 0))
    }
    public static var black: NSColor {
        return .init(RBColor.init(red: 0, green: 0, blue: 0, opacity: 1))
    }
    public static var white: NSColor {
        return .init(RBColor.init(red: 1, green: 1, blue: 1, opacity: 1))
    }
    public static var gray: NSColor {
        return .init(RBColor.init(red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
    }
    public static var red: NSColor {
        return .init(RBColor.init(red: 1, green: 0, blue: 0, opacity: 1))
    }
    public static var green: NSColor {
        return .init(RBColor.init(red: 0, green: 1, blue: 0, opacity: 1))
    }
    public static var blue: NSColor {
        return .init(RBColor.init(red: 0, green: 0, blue: 1, opacity: 1))
    }
    public static var orange: NSColor {
        return .init(RBColor.init(red: 1, green: 0.5, blue: 0, opacity: 1))
    }
    public static var yellow: NSColor {
        return .init(RBColor.init(red: 1, green: 1, blue: 0, opacity: 1))
    }
    public static var purple: NSColor {
        return .init(RBColor.init(red: 0.5, green: 0, blue: 0.5, opacity: 1))
    }
}
