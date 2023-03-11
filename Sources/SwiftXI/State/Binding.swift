@propertyWrapper @dynamicMemberLookup public struct Binding<Value> {
    public var transaction: Transaction
    @Box var location: AnyLocation<Value>
    var _value: Value

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.init(get: get) { (v, _) in set(v) }
    }

    public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void) {
        let location = LocationBox.init(FunctionalLocation.init(getValue: get, setValue: set))
        self.init(location)
    }

    init(_ location: AnyLocation<Value>, transaction: Transaction = .init()) {
        self._value = location.bindingValue
        _location = .init(initialValue: location)
        self.transaction = transaction
    }
    public static func constant(_ value: Value) -> Binding<Value> {
        let loc = LocationBox.init(ConstantLocation.init(value: value))
        return .init(loc)
    }

    public var wrappedValue: Value {
        get { return location.value }
        nonmutating set {
            location.setBindingValue(newValue, t: transaction)
        }
    }

    public var projectedValue: Binding<Value> {
        return self
    }

    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        let loc = LocationBox.init(ProjectedLocation.init(location: location, projection: keyPath))
        return .init(loc)
    }
}

extension Binding {
    public func transaction(_ transaction: Transaction) -> Binding<Value> {
        var binding = self
        binding.transaction = transaction
        return binding
    }
    // public func animation(_ animation: Animation? = .default) -> Binding<Value>
}

extension Binding: DynamicProperty {
}

extension Binding {
    public init<V>(_ base: Binding<V>) where Value == V? {
        let location = base.location
        let projection = BindingOperations.ToOptional<V>.init()
        let loc = LocationBox.init(ProjectedLocation.init(location: location, projection: projection))
        self.init(loc)
    }
    public init?(_ base: Binding<Value?>) {
        guard let _ = base.wrappedValue else {
            return nil
        }
        let location = base.location
        let projection = BindingOperations.ForceUnwrapping<Value>.init()
        let loc = LocationBox.init(ProjectedLocation.init(location: location, projection: projection))
        self.init(loc)
    }
    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V: Hashable {
        let location = base.location
        let projection = BindingOperations.ToAnyHashable<V>.init()
        let loc = LocationBox.init(ProjectedLocation.init(location: location, projection: projection))
        self.init(loc)
    }
}

