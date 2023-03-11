import Foundation

public typealias CGAffineTransform = AffineTransform

 extension CGAffineTransform {
    public init(translationX tx: CGFloat, y ty: CGFloat) {
        self.init(translationByX: tx, byY: ty)
    }
    public init(scaleX sx: CGFloat, y sy: CGFloat) {
        self.init(scaleByX: sx, byY: sy)
    }
    public init(rotationAngle angle: CGFloat) {
        self.init(rotationByRadians: angle)
    }
    public var isIdentity: Bool {
        return self == .identity
    }
    public func translatedBy(x tx: CGFloat, y ty: CGFloat) -> CGAffineTransform{
        var result = self 
        result.translate(x: tx, y: ty)
        return result
    }
    public func scaledBy(x sx: CGFloat, y sy: CGFloat) -> CGAffineTransform{
        var result = self 
        result.scale(x: sx, y: sy)
        return result
    }
    public func rotated(by angle: CGFloat) -> CGAffineTransform{
        var result = self 
        result.rotate(byDegrees: angle)
        return result
    }
    public func concatenating(_ t2: CGAffineTransform) -> CGAffineTransform {
        var result = self 
        result.append(t2)
        return result
    }
}

extension CGPoint {
    public func applying(_ t: CGAffineTransform) -> CGPoint{
        return t.transform(self)
    }
}
extension CGSize {
    public func applying(_ t: CGAffineTransform) -> CGSize{
        return t.transform(self)
    }
}
extension CGRect {
    public func applying(_ t: CGAffineTransform) -> CGRect{
        let p = self.origin.applying(t)
        let s = self.size.applying(t)
        return .init(origin: p, size: s)
    }
}

public struct Angle {
    public var radians: Double
    @inlinable public var degrees: Double {
        return radians / Double.pi * 180.0
    }
    @inlinable public init() {
        radians = 0
    }
    @inlinable public init(radians: Double) {
        self.radians = radians
    }
    @inlinable public init(degrees: Double) {
        self.radians = degrees / 180.0 * Double.pi
    }
    @inlinable public static func radians(_ radians: Double) -> Angle {
        return .init(radians: radians)
    }
    @inlinable public static func degrees(_ degrees: Double) -> Angle {
        return .init(degrees: degrees)
    }
}

extension Angle: Hashable, Comparable {
    @inlinable public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians < rhs.radians
    }
}