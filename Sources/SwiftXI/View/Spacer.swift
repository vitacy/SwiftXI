import Foundation

public struct Spacer {
    public var minLength: CGFloat?
    @inlinable public init(minLength: CGFloat? = nil){
        self.minLength = minLength
    }
    public typealias Body = Never
}

extension Spacer : View {
}

extension Spacer : _NeverPublicBody{
}