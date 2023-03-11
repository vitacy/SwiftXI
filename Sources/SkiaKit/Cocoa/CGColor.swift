import Foundation

open class AnyColorBox: Hashable, CustomStringConvertible, RBColorConvertible {
    public init(){}
    open func hash(into hasher: inout Hasher) {
        hasher.combine(self.description.hashValue)
    }
    public static func == (lhs: AnyColorBox, rhs: AnyColorBox) -> Bool {
        return lhs.description == rhs.description
    }
    open var description: String {
        return "\(Self.self)"
    }
    open func toSRGBColor() -> RBColor{
        fatalError()
    }
}
public final class ColorBox<Content: Hashable>: AnyColorBox where Content: RBColorConvertible{
    var base: Content
    public init(_ c: Content) {
        base = c
    }
    public override var description: String {
        return "\(base)"
    }
    public override func toSRGBColor() -> RBColor{
        return base.toSRGBColor()
    }
}
extension CGColor: RBColorConvertible{
    public func toSRGBColor() -> RBColor{
        return base.toSRGBColor()
    }
}
public protocol RBColorConvertible {
    func toSRGBColor() -> RBColor
}
public struct RBColor: Hashable, CustomStringConvertible{
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var opacity: CGFloat

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat){
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    public var description: String {
        return "\(red) \(green) \(blue) \(opacity)"
    }
}
extension RBColor: RBColorConvertible{
    public func toSRGBColor() -> RBColor{
        return self
    }
}
public class CGColor: Hashable, CustomStringConvertible{
    var base: AnyColorBox
    public init(_ base: AnyColorBox){
        self.base = base
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.description.hashValue)
    }
    public static func == (lhs: CGColor, rhs: CGColor) -> Bool {
        return lhs.description == rhs.description
    }
    public var description: String {
        return "\(Self.self)"
    }
}


public class CGColorSpace {
    let name: String
    public init(_ name: String){
        self.name = name
    }
}
extension CGColorSpace {
    public static let genericRGBLinear: String = "kCGColorSpaceGenericRGBLinear"
    public static let sRGB: String  = "kCGColorSpaceSRGB"
    public static let linearSRGB: String  = "kCGColorSpaceLinearSRGB"

    public convenience init?(name: String){
        self.init(name)
    }
}

public enum CGColorRenderingIntent : Int32 {
    case defaultIntent = 0
}