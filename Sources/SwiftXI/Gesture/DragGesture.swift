public struct DragGesture: Gesture {
    public struct Value: Equatable {
        public var time: Date
        public var location: CGPoint
        public var startLocation: CGPoint
        public var translation: CGSize {
            return .init(width: location.x - startLocation.x, height: location.y - startLocation.y)
        }
        public var predictedEndLocation: CGPoint {
            return location
        }
        public var predictedEndTranslation: CGSize {
            return translation
        }
    }

    public var minimumDistance: CGFloat
    public var coordinateSpace: CoordinateSpace
    public init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
    }
}

extension DragGesture: _NeverPublicBody {
}

extension DragGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue){
        value.waitEventMask = .none
        processEventInternal(event, value: value, node: node)
        if value.status == .begin && value.waitEventMask == .none{
            value.status = .ended
        }
    }
    func processEventInternal(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        let maxWaitTime = 100.0
        let location = event.locationInWindow - node.modifier.geometry.absolutePosition
        if event.type == .leftMouseDown {
            guard value.status == .none else {
                return
            }
            let date = Date.init(timeIntervalSinceReferenceDate: event.timestamp)
            value.value = Value.init(time: date, location: location, startLocation: location)
            value.status = .initially
            value.lastTime = event.timestamp
            value.lastPoint = event.locationInWindow
            value.waitEventMask = acceptEventMask()
            value.waitTimeout = maxWaitTime
            if minimumDistance == 0 {
                value.status = .begin
            }
            return
        }
        guard value.status == .initially || value.status == .begin else {
            return
        }
        let date = Date.init(timeIntervalSinceReferenceDate: event.timestamp)
        let lastValue = value.value as! Value
        let v = Value.init(time: date, location: location, startLocation: lastValue.startLocation)

        
        if event.type == .leftMouseDragged {
            value.waitEventMask = acceptEventMask()
            if location.distence(to: lastValue.location) > minimumDistance {
                value.value = v

                if value.status == .initially {
                    value.status = .begin
                }
            }
            if value.status == .begin {
                event.consumed = true
            }
        }
        if event.type == .leftMouseUp && value.status == .begin {
            value.status = .ended
            event.consumed = true
            value.value = v
        }
    }
    func acceptEventMask() -> NSEvent.EventTypeMask {
        return .leftMouseUp.union(.leftMouseDown).union(.leftMouseDragged)
    }
}
