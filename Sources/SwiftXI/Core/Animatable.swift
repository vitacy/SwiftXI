public protocol Animatable{
    associatedtype AnimatableData : VectorArithmetic
    var animatableData: Self.AnimatableData { get set }
}

extension Animatable where Self : VectorArithmetic {
    public var animatableData: Self{
        get {return self}
        set {self = newValue}
    }
}
extension Animatable where Self.AnimatableData == EmptyAnimatableData {
    public var animatableData: EmptyAnimatableData{
        get { return .init() }
        set {}
    }
}
struct BezierTimingCurve: Equatable{
    var c1: CGPoint
    var c2: CGPoint
    func valueAt(percent t: Double) -> Double{
        //P = (1−t)3P1 + 3(1−t)2tP2 +3(1−t)t2P3 + t3P4
        let p = 3*(1-t)*(1-t)*t * c1.y + 3*(1-t)*t*t * c2.y + t*t*t
        return p
    }
}
struct BezierAnimation : Equatable{
    var duration: Double
    var curve: BezierTimingCurve
    func scaleValue(_ time: Double) -> Double{
        let percent = min(time/duration, 1)
        return curve.valueAt(percent: percent)
    }
}
public struct Animation : Equatable {
    var base: BezierAnimation
    func scaleValue(_ time: Double) -> Double{
        return base.scaleValue(time)
    }
}

extension Animation {
    public static let `default`: Animation = easeInOut
    public static func easeInOut(duration: Double) -> Animation{
        return timingCurve(0.4, 0, 0.6, 1, duration: duration)
    }

    public static var easeInOut: Animation { 
        return easeInOut(duration: 0.35)
     }

    public static func easeIn(duration: Double) -> Animation{
        return timingCurve(0.4, 0, 0.85, 0.8, duration: duration)
    }

    public static var easeIn: Animation { 
        return easeIn(duration: 0.35)
    }

    public static func easeOut(duration: Double) -> Animation{
        return timingCurve(0.15, 0.2, 0.6, 1, duration: duration)
    }

    public static var easeOut: Animation { 
        return easeOut(duration: 0.35)
    }

    public static func linear(duration: Double) -> Animation{
        return timingCurve(0.25, 0.25, 0.75, 0.75, duration: duration)
    }

    public static var linear: Animation { 
        return linear(duration: 0.35)
    }
    public static func timingCurve(_ c0x: Double, _ c0y: Double, _ c1x: Double, _ c1y: Double, duration: Double = 0.35) -> Animation{
        let b = BezierAnimation.init(duration: duration, curve: .init(c1: .init(x: c0x, y: c0y), c2: .init(x: c1x, y: c1y)))
        return .init(base: b)
    }
}

extension CGPoint : Animatable {
    public var animatableData: AnimatablePair<CGFloat, CGFloat>{
        get {return .init(x, y)}
        set {
            x = newValue.first
            y = newValue.second
        }
    }
}
extension CGSize : Animatable {
    public var animatableData: AnimatablePair<CGFloat, CGFloat>{
        get {return .init(width, height)}
        set {
            width = newValue.first
            height = newValue.second
        }
    }
}

extension CGRect : Animatable {
    public var animatableData: AnimatablePair<CGPoint.AnimatableData, CGSize.AnimatableData>{
        get {return .init(origin.animatableData, size.animatableData)}
        set {
            origin.animatableData = newValue.first
            size.animatableData = newValue.second
        }
    }
}
