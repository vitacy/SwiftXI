public struct EmptyView: View {
    public typealias Body = Never

    @inlinable public init() {
    }
}

extension EmptyView : _NeverPublicBody{
}