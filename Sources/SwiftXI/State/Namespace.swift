@propertyWrapper public struct Namespace : DynamicProperty {
    @Box var id: ID = .init()

    @inlinable public init(){}

    public var wrappedValue: Namespace.ID { return id }

    public struct ID : Hashable {
        static var _autoIncrement = 1
        static var autoIncrement: ID {
            var increment = 0
            _autoIncrement += 1
            increment = _autoIncrement
            return .init(id: increment)
        }

        var id: Int = 0
    }
}
