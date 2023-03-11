struct PropertyList {
    var elements: PropertyList.Element? = nil

    func forEach(_ body: (PropertyList.Element) throws -> Void) rethrows{
        var e = elements
        while let item = e {
            try body(item)
            e = e?.after
        }
    }
    func first(where predicate: (PropertyList.Element) throws -> Bool) rethrows -> PropertyList.Element?{
        var e = elements
        while let item = e {
            if try predicate(item){
                return item
            }
            e = e?.after
        }
        return nil
    }
    subscript<Key: PropertyListKey>(element key: Key.Type) -> TypedElement<Key>?{
        get{ return first{ $0.keyType == key } as? TypedElement<Key> }
        set{ 
            if let e = newValue{
                e.after = elements
                e.length = 1 + (elements?.length ?? 0)

                elements = e
            }
        }
    }
    subscript<Key: PropertyListKey>(key: Key.Type) -> Key.Value?{
        get {
            return self[element: key]?.value
        }
        set {
            if let newValue = newValue{
                let e = TypedElement<Key>.init(keyType: key, value: newValue)
                self[element: key] = e
            }
        }
    }
}
extension PropertyList {
    class Tracker {
    }
}
protocol PropertyListKey{
    associatedtype Value
}
extension PropertyList {
    class Element {
        var keyType: Any.Type
        var before: Element? = nil
        var after: Element? = nil
        var length: Int 
        // var keyFilter: BloomFilter
        init(keyType: Any.Type){
            self.keyType = keyType
            length = 1
        }
    }
    class TypedElement<Key: PropertyListKey>: Element{
        typealias Value = Key.Value
        var value: Key.Value
        init(keyType: Any.Type, value: Value){ 
            self.value = value
            super.init(keyType: keyType)
        }
    }
}