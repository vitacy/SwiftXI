extension View {
    public func layoutPriority(_ value: Double) -> some View{
        return modifier(_TraitWritingModifier<LayoutPriorityTraitKey>.init(value: value))
    }
    public func zIndex(_ value: Double) -> some View{
        return modifier(_TraitWritingModifier<ZIndexTraitKey>.init(value: value))
    }
}

struct _TraitWritingModifier<Key: _ViewTraitKey>: ViewModifier{
    typealias Body = Never
    typealias Value = Key.Value
    let value: Value
}

protocol _ViewTraitKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

struct ZIndexTraitKey: _ViewTraitKey{
    static var defaultValue: Double {
        return 0
    }
}

struct LayoutPriorityTraitKey: _ViewTraitKey{
    static var defaultValue: Double {
        return 0
    }
}
extension _TraitValues {
    var zIndex: Double {
        get { return self[ZIndexTraitKey.self] }
        set { self[ZIndexTraitKey.self] = newValue }
    }
    var layoutPriority: Double {
        get { return self[LayoutPriorityTraitKey.self] }
        set { self[LayoutPriorityTraitKey.self] = newValue }
    }
}

struct _TraitValues {
    var values: [ObjectIdentifier: Any] = [:]
    
    subscript<K>(key: K.Type) -> K.Value where K: _ViewTraitKey {
        get {
            if let value = values[ObjectIdentifier(key)] as? K.Value {
                return value
            }
            return K.defaultValue
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
    subscript<K>(key: K.Type) -> K.Value where K: LayoutValueKey {
        get {
            if let value = values[ObjectIdentifier(key)] as? K.Value {
                return value
            }
            return K.defaultValue
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
}