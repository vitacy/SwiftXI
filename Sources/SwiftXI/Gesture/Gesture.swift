public protocol Gesture {
    associatedtype Value
    associatedtype Body : Gesture
    var body: Self.Body { get }
}

public struct GestureMask : OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32){
        self.rawValue = rawValue
    }
    public static let none: GestureMask = .init(rawValue: 0)
    public static let gesture: GestureMask = .init(rawValue: 1)
    public static let subviews: GestureMask = .init(rawValue: 2)
    public static let all: GestureMask = .init(rawValue: 1+2)
}

// extension Gesture {
//     public func modifiers(_ modifiers: EventModifiers) -> _ModifiersGesture<Self>
// }
// extension Gesture {
//     @inlinable public func simultaneously<Other>(with other: Other) -> SimultaneousGesture<Self, Other> where Other : Gesture
// }
// extension Gesture {
//     public func map<T>(_ body: @escaping (Self.Value) -> T) -> _MapGesture<Self, T>
// }
// extension Gesture {
//     @inlinable public func exclusively<Other>(before other: Other) -> ExclusiveGesture<Self, Other> where Other : Gesture
// }
// extension Gesture {
//     @inlinable public func sequenced<Other>(before other: Other) -> SequenceGesture<Self, Other> where Other : Gesture
// }

