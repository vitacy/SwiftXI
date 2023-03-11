public protocol DynamicProperty {
    mutating func update()
}
extension DynamicProperty {
    public mutating func update() {
    }
}

public struct _DynamicPropertyBuffer {
}

@propertyWrapper public struct State<Value>: DynamicProperty {
    var _value: Value
    @Box var _location: AnyLocation<Value>? = nil

    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }
    public init(wrappedValue value: Value) {
        _value = value
    }
    public var wrappedValue: Value {
        get { return _location?.value ?? _value }
        nonmutating set { _location?.value = newValue }
    }
    public var projectedValue: Binding<Value> {
        return Binding(get: { return self.wrappedValue }, set: { newValue in self.wrappedValue = newValue })
    }
}

extension State where Value: ExpressibleByNilLiteral {
    public init() {
        self.init(wrappedValue: nil)
    }
}

class AnyLocationBase {
}

class AnyLocation<Value>: AnyLocationBase {
    typealias ValueType = Value

    override init(){}
    init(value: Value) {
    }
    var value: Value {
        get { fatalError() }
        set {}
    }
    func update(){}

    func setBindingValue(_ value: ValueType, t: Transaction){
        self.value = value
    }
}
class StoredLocationBase<Value>: AnyLocation<Value> {
    var _value: Value
    var wasRead = false
    override init(value: Value) {
        _value = value
        super.init(value: value)
    }
    override var value: Value {
        get {
            wasRead = true
            return _value
        }
         set {
            _value = newValue
            if wasRead {
                update()
            }
        }
    }
}

