extension Gesture {
    public func onChanged(_ action: @escaping (Self.Value) -> Void) -> _ChangedGesture<Self> {
        let callback = CallbacksGesture.init(callbacks: ChangedCallbacks.init(ended: action))
        let modifier = ModifierGesture.init(content: self, modifier: callback)
        return _ChangedGesture.init(_body: modifier)
    }
}

public struct _ChangedGesture<T: Gesture>: Gesture {
    public typealias Value = T.Value
    var _body: ModifierGesture<CallbacksGesture<ChangedCallbacks<T.Value>>, T>
}
extension _ChangedGesture: _NeverPublicBody {
}

struct ChangedCallbacks<T> {
    var ended: (T) -> Void
}

extension _ChangedGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
         _body.processEvent(event, value: value, node: node)
        if value.status == .begin && value.valueChanged {
            (value.value as? Value).map{_body.modifier.callbacks.ended($0)}
        }
    }
}