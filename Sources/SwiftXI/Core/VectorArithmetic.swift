public protocol VectorArithmetic : AdditiveArithmetic {
    mutating func scale(by rhs: Double)
    var magnitudeSquared: Double { get }
}

public struct EmptyAnimatableData : VectorArithmetic {
    @inlinable public init(){}
    @inlinable public static var zero: EmptyAnimatableData { return .init() }
    @inlinable public static func += (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData){
    }
    @inlinable public static func -= (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData){
    }
    @inlinable public static func + (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData{
        return .init()
    }
    @inlinable public static func - (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData{
        return .init()
    }
    @inlinable public mutating func scale(by rhs: Double){
    }
    @inlinable public var magnitudeSquared: Double { return 0 }
    public static func == (a: EmptyAnimatableData, b: EmptyAnimatableData) -> Bool{
        return true
    }
}

public struct AnimatablePair<First, Second> : VectorArithmetic where First : VectorArithmetic, Second : VectorArithmetic {
    public var first: First
    public var second: Second
    @inlinable public init(_ first: First, _ second: Second){
        self.first = first
        self.second = second
    }

    public static var zero: AnimatablePair<First, Second> { return .init(.zero, .zero) }

    public static func += (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>){
        lhs.first += rhs.first
        lhs.second += rhs.second
    }

    public static func -= (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>){
        lhs.first -= rhs.first
        lhs.second -= rhs.second
    }

    public static func + (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second>{
        var result = lhs
        result += rhs 
        return result
    }

    public static func - (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second>{
        var result = lhs
        result -= rhs 
        return result
    }
    public mutating func scale(by rhs: Double){
        self.first.scale(by: rhs)
        self.second.scale(by: rhs)
    }

    public var magnitudeSquared: Double { return first.magnitudeSquared + second.magnitudeSquared }

    public static func == (a: AnimatablePair<First, Second>, b: AnimatablePair<First, Second>) -> Bool{
        return a.first == b.first && a.second == b.second
    }
}

extension CGFloat : VectorArithmetic {
    public mutating func scale(by rhs: Double){
        self *= rhs
    }
    public var magnitudeSquared: Double { 
        return self * self 
    }
}
extension Float : VectorArithmetic {
    public mutating func scale(by rhs: Double){
        self *= Float(rhs)
    }
    public var magnitudeSquared: Double { 
        return Double(self) * Double(self)
    }
}
extension Double : VectorArithmetic {
    public mutating func scale(by rhs: Double){
        self *= rhs
    }
    public var magnitudeSquared: Double { 
        return self * self
    }
}

extension VectorArithmetic{
    func applying(_ animation: Animation, time: Double, from: Self, to: Self) -> Self{
        let scale = animation.scaleValue(time)
        var value: Self = to-from
        value.scale(by: scale)
        value += from
        return value
    }
}