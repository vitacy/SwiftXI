public struct TapGesture: Gesture {
    public var count: Int
    public init(count: Int = 1) {
        self.count = count
    }
    public typealias Value = ()
}
extension View {
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        return gesture(TapGesture.init(count: count).onEnded(action))
    }
}

extension TapGesture: _NeverPublicBody{
}

extension TapGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue){
        processEventInternal(event, value: value)
    }
    func processEventInternal(_ event: NSEvent, value: _GestureValue) {
        if count <= 0 || event.clickCount == 0 {
            return
        }
        if (event.type == .leftMouseDragged){
            let maximumDistance = 10.0
            if(value.lastPoint.distence(to: event.locationInWindow) > maximumDistance){
                return
            }
            value.lastPoint = event.locationInWindow
        }
        let curCount = event.clickCount % count
        if event.type == .leftMouseDown && value.status == .none && (curCount == 1 || count==1){
            value.status = .initially
            value.waitTimeout = NSEvent.doubleClickInterval*Double(count)
            value.lastPoint = event.locationInWindow
        }
        if event.type == .leftMouseUp && value.status == .initially && curCount == 0{
            value.status = .ended
            event.consumed = true
            return
        }
        if value.status == .initially{
            value.waitEventMask = acceptEventMask()
        }
    }

    func acceptEventMask() -> NSEvent.EventTypeMask{
        return .leftMouseUp.union(.leftMouseDown).union(.leftMouseDragged)
    }
}