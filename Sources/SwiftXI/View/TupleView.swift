public struct TupleView<T>: View {
    public var value: T

    @inlinable public init(_ value: T) {
        self.value = value
    }
}

extension TupleView: _NeverPublicBody{
}