protocol AnyBindingLocation {
    associatedtype BindingValue
    var bindingValue: BindingValue {
        get
    }
    func setBindingValue(_ value: BindingValue, t: Transaction)
}
extension AnyLocation: AnyBindingLocation {
    var bindingValue: Value {
        return self.value
    }
}
class LocationBox<T: AnyBindingLocation>: AnyLocation<T.BindingValue> {
    let location: T
    init(_ location: T) {
        self.location = location
        super.init()
    }
    override var value: ValueType {
        get { return location.bindingValue }
        set {}
    }
    override func setBindingValue(_ value: ValueType, t: Transaction) {
        location.setBindingValue(value, t: t)
    }

    struct ScopedLocation: AnyBindingLocation {
        var base: LocationBox<T>
        var wasRead: Bool = false
        var bindingValue: BindingValue {
            return base.bindingValue
        }
        func setBindingValue(_ value: ValueType, t: Transaction) {
            base.setBindingValue(value, t: t)
        }
    }
}

struct ConstantLocation<T>: AnyBindingLocation {
    typealias ValueType = T
    let value: ValueType
    var bindingValue: ValueType {
        return self.value
    }
    func setBindingValue(_ value: ValueType, t: Transaction) {
    }
}
protocol _AnyBindingProjection {
    associatedtype ValueType
    associatedtype InputType
    associatedtype SetterWithInputType = Never

    func fromBindingValue(_ input: InputType) -> ValueType
    func setBindingValue(_ value: ValueType, input: InputType)
    func toBindingValue(_ value: ValueType) -> InputType
}
extension _AnyBindingProjection {
    func setBindingValue(_ value: ValueType, input: InputType) {
    }
}
enum BindingOperations {
    struct ToOptional<T>: _AnyBindingProjection{
        func fromBindingValue(_ input: T) -> T? {
            return input
        }
        func toBindingValue(_ value: T?) -> T {
            return value!
        }
    }
    struct ForceUnwrapping<T>: _AnyBindingProjection {
        func fromBindingValue(_ input: T?) -> T {
            return input!
        }
        func toBindingValue(_ value: T) -> T? {
            return value
        }
    }
    struct ToAnyHashable<T: Hashable>: _AnyBindingProjection{
        func fromBindingValue(_ input: T) -> AnyHashable {
            return .init(input)
        }
        func toBindingValue(_ value: AnyHashable) -> T {
            return value.base as! T
        }
    }
}
extension WritableKeyPath: _AnyBindingProjection {
    func fromBindingValue(_ input: Root) -> Value {
        return input[keyPath: self]
    }

    func setBindingValue(_ value: Value, input: Root) {
        var input = input
        input[keyPath: self] = value
    }
    func toBindingValue(_ value: Value) -> Root {
        fatalError()
    }
}
struct ProjectedLocation<T: AnyBindingLocation, Projection: _AnyBindingProjection>: AnyBindingLocation where T.BindingValue == Projection.InputType {
    typealias ValueType = Projection.ValueType
    var location: T
    var projection: Projection

    var value: ValueType {
        return projection.fromBindingValue(location.bindingValue)
    }
    var bindingValue: ValueType {
        return self.value
    }
    func setBindingValue(_ value: ValueType, t: Transaction) {
        if Projection.SetterWithInputType.self is Never.Type {
            location.setBindingValue(projection.toBindingValue(value), t: t)
        } else {
            let input = location.bindingValue
            projection.setBindingValue(value, input: input)
        }
    }
}

struct FunctionalLocation<Value>: AnyBindingLocation {
    var getValue: () -> Value
    var setValue: (Value, Transaction) -> Void

    var bindingValue: Value {
        return getValue()
    }
    func setBindingValue(_ value: Value, t: Transaction) {
        setValue(value, t)
    }
}
