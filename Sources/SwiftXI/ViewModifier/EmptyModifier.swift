public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = .init()
    public typealias Body = Never
    @inlinable public init(){
    }
}