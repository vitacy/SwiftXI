@propertyWrapper public struct GestureState<Value>: DynamicProperty {
    var state: State<Value>
    var reset: (Binding<Bool>) -> Void
    public init(wrappedValue: Value) {
        state = .init(wrappedValue: wrappedValue)
        reset = { _ in }
    }
    public init(initialValue: Value) {
        self.init(wrappedValue: initialValue)
    }
    public init(wrappedValue: Value, resetTransaction: Transaction) {
        self.init(wrappedValue: wrappedValue)
    }
    public init(initialValue: Value, resetTransaction: Transaction) {
        self.init(wrappedValue: initialValue)
    }
    public init(wrappedValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: wrappedValue)
    }
    public init(initialValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: initialValue)
    }
    public var wrappedValue: Value {
        return state.wrappedValue
    }
    public var projectedValue: GestureState<Value> {
        return self
    }
}

extension GestureState where Value: ExpressibleByNilLiteral {
    public init(resetTransaction: Transaction = Transaction()) {
        self.init(initialValue: nil, resetTransaction: resetTransaction)
    }
    public init(reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(initialValue: nil, reset: reset)
    }
}

public struct GestureStateGesture<Base, State>: Gesture where Base: Gesture {
    public typealias Value = Base.Value
    public var base: Base
    public var state: GestureState<State>
    public var closure: (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void

    @inlinable public init(
        base: Base,
        state: GestureState<State>,
        body: @escaping (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void
    ) {
        self.base = base
        self.state = state
        self.closure = body
    }
}
extension Gesture {
    @inlinable public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.Value, inout State, inout Transaction) -> Void)
        -> GestureStateGesture<Self, State>
    {
        return .init(base: self, state: state, body: body)
    }
}
extension GestureStateGesture: _NeverPublicBody {
}
