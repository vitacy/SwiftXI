protocol _MakeDynamicProperty {
    mutating func _makeProperty(node: AnyASTNode, forKey: String)
}
class StoredLocation<Value>: StoredLocationBase<Value> {
    weak var node: AnyASTNode? = nil
    override func update() {
        node?.update()
    }
}

extension State: _MakeDynamicProperty {
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {
        if let location: StoredLocation<Value> = node.stateForKey(forKey).asType() {
            self._location = location
            return
        }

        let location = StoredLocation<Value>.init(value: self.wrappedValue)
        location.node = node
        self._location = location
        node.setStateForKey(location, forKey: forKey)
    }
}

extension StateObject: _MakeDynamicProperty {
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {
        guard case .initially(_) = storage else{
            return
        }

        if let object: ObservedObject<ObjectType> = node.stateForKey(forKey).asType() {
            storage = .object(object)
            return
        }

        let value = wrappedValue
        var object = ObservedObject<ObjectType>.init(initialValue: value)
        storage = .object(object)
        object._makeProperty(node: node, forKey: "observer:"+forKey)

        node.setStateForKey(object, forKey: forKey)
    }
}
extension ObservedObject: _MakeDynamicProperty{
    struct _Subscriber{
        let subscriber: AnyCancellable
        weak var object: ObjectType?

        func cancel(){
            subscriber.cancel()
        }
    }
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {
        if let state: _Subscriber = node.stateForKey(forKey).asType() {
            if (state.object === wrappedValue){
                return
            }
            state.cancel()
        }

        weak var weakNode = node
        let subscriber = wrappedValue.objectWillChange.sink(receiveValue: { _ in weakNode?.update() })
        let state = _Subscriber.init(subscriber: subscriber, object: wrappedValue)
        node.setStateForKey(state, forKey: forKey)
    }
}
extension Binding: _MakeDynamicProperty {
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {

    }
}


extension Environment: _MakeDynamicProperty{
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {
        if case let .keyPath( keyPath) = content{
            self.content = .value(node.environments[keyPath: keyPath])
        }
    }
}

extension Namespace: _MakeDynamicProperty {
    mutating func _makeProperty(node: AnyASTNode, forKey: String) {
        if let id: Namespace.ID = node.stateForKey(forKey).asType() {
            self.id = id
            return
        }

        let id = Namespace.ID.autoIncrement
        self.id = id
        node.setStateForKey(id, forKey: forKey)
    }
}