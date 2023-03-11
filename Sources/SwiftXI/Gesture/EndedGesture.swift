extension Gesture {
    public func onEnded(_ action: @escaping (Self.Value) -> Void) -> some Gesture {
        let callback = CallbacksGesture.init(callbacks: EndedCallbacks.init(ended: action))
        let modifier = ModifierGesture.init(content: self, modifier: callback)
        return _EndedGesture.init(_body: modifier)
    }
}

struct _EndedGesture<T: Gesture>: Gesture {
    typealias Value = T.Value
    var _body: ModifierGesture<CallbacksGesture<EndedCallbacks<T.Value>>, T>
}
extension _EndedGesture: _NeverPublicBody{
}

struct EndedCallbacks<T> {
    var ended: (T) -> Void
}

extension _EndedGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        _body.processEvent(event, value: value, node: node)
        if value.status == .ended {
            (value.value as? Value).map{_body.modifier.callbacks.ended($0)}
        }
    }
}