public struct LongPressGesture : Gesture {
    public var minimumDuration: Double
    public var maximumDistance: CGFloat

    public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10){
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }

    public typealias Value = Bool
}
extension LongPressGesture: _NeverPublicBody{
}


extension View{
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, pressing: ((Bool) -> Void)? = nil, perform action: @escaping () -> Void) -> some View{
        let gesture = LongPressGesture.init(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        let callback = CallbacksGesture.init(callbacks: PressableGestureCallbacks.init(pressing: pressing, pressed: action))
        let modifier = ModifierGesture.init(content: gesture, modifier: callback)
        return self.gesture(_PressableGesture.init(_body: modifier))
    }
}

struct PressableGestureCallbacks<T> {
    var pressing: ((T) -> Void)?
    var pressed: (() -> Void)?
}

struct _PressableGesture<T: Gesture>: Gesture where T.Value == Bool{
    typealias Value = T.Value
    var _body: ModifierGesture<CallbacksGesture<PressableGestureCallbacks<T.Value>>, T>
}
extension _PressableGesture: _NeverPublicBody{
}

extension _PressableGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        _body.processEvent(event, value: value, node: node)
        if value.status == .none{
            return
        }
        if value.status != .ended && value.status != .failed{
            if value.waitEventMask == .none || event.type == .leftMouseUp{
                value.status = .failed
            }
        }
        
        if event.type == .leftMouseDown{
            _body.modifier.callbacks.pressing?(true)
        }
        if(value.status == .ended || value.status == .failed){
            _body.modifier.callbacks.pressing?(false)
        }
        if value.status == .ended {
            _body.modifier.callbacks.pressed?()
        }
    }
}
extension LongPressGesture: _GestureProcess {
    func processEventInternal(_ event: NSEvent, value: _GestureValue) {
        if event.type == .leftMouseDown {
            guard value.status == .none else{
                return
            }
            value.status = .initially
            value.lastTime = event.timestamp
            value.lastPoint = event.locationInWindow
            value.waitEventMask = .leftMouseDragged.union(.leftMouseUp)
            value.waitTimeout = minimumDuration
            value.value = true
            event.consumed = true
            return
        }
        guard value.status == .initially else{
            return
        }
        if event.type != .timeout && event.locationInWindow.distence(to: value.lastPoint) > maximumDistance {
            return
        }

        let elapsed = event.timestamp - value.lastTime
        if elapsed > minimumDuration {
            value.status = .ended
            event.consumed = true
            return
        }
        
        if event.type == .leftMouseDragged{
            value.waitEventMask = .leftMouseDragged.union(.leftMouseUp)
        }
    }
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue){
        value.waitEventMask = .none
        if !acceptEventMask().contains(.init(eventType: event.type)){
            return
        }
        if (event.consumed){
            return
        }
        processEventInternal(event, value: value)
    }
    func acceptEventMask() -> NSEvent.EventTypeMask {
        return .leftMouseUp.union(.leftMouseDown).union(.leftMouseDragged).union(.timeout)
    }
}
