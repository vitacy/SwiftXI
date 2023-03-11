@propertyWrapper public struct StateObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {
    @usableFromInline enum Storage{
        case initially(() -> ObjectType)
        case object(ObservedObject<ObjectType>)
    }
    @Box var storage: Storage

    public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType){
        storage = .initially(thunk)
    }
    public var wrappedValue: ObjectType { 
        switch storage{
            case .initially(let thunk): return thunk()
            case .object(let obj): return obj.wrappedValue
        }
    }
    public var projectedValue: ObservedObject<ObjectType>.Wrapper { 
        return .init(root: wrappedValue)
    }
}


@propertyWrapper public struct ObservedObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {
    @dynamicMemberLookup @frozen public struct Wrapper {
        var root: ObjectType
        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> { 
            let loc = LocationBox.init(ObservableObjectLocation.init(base: root, keyPath: keyPath))
            return .init(loc)
         }
    }

    var _seed: Int = 0
    public var wrappedValue: ObjectType

    public init(initialValue: ObjectType){
        self.init(wrappedValue: initialValue)
    }
    public init(wrappedValue: ObjectType){
        self.wrappedValue = wrappedValue
    }
    public var projectedValue: ObservedObject<ObjectType>.Wrapper { 
        return .init(root: wrappedValue)
    }
}

struct ObservableObjectLocation<T, Value>: AnyBindingLocation{
    var base: T
    var keyPath: ReferenceWritableKeyPath<T, Value>
    var bindingValue: Value {
        return base[keyPath: keyPath]
    }
    func setBindingValue(_ value: Value, t: Transaction) {
        base[keyPath: keyPath] = value
    }
}