@propertyWrapper class Box<Value>: CustomStringConvertible {
    var wrappedValue: Value

    convenience init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }
    init(wrappedValue value: Value) {
        wrappedValue = value
    }
    var description: String{
        return "Box \(wrappedValue)"
    }
}