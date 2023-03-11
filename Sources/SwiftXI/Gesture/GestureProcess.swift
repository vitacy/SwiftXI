protocol _EventProcess {
    func processEvent(_ event: NSEvent, node: _GestureContextValue)
}
protocol _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue)
}


class _GestureValue {
    enum _GestureStatus {
        case none
        case initially
        case begin
        case failed
        case ended
    }
    var transaction: Transaction = .init()
    var status: _GestureStatus = .none
    var waitEventMask: NSEvent.EventTypeMask = [.leftMouseDown, .rightMouseDown]

    var waitTimeout: TimeInterval = 5
    var lastTime: TimeInterval = 0
    var lastEventTime: DispatchTime = .now()
    var lastPoint: CGPoint = .zero
    var data: Any? = nil

    var valueChanged = false
    var value: Any = () {
        didSet {
            valueChanged = true
        }
    }
}
final class _GestureContextValue{
    let modifier: _ViewElementNode
    let view: _ViewElementNode
    var simultaneousGesture = false
    var value = _GestureValue.init()
    var tempZIndex: Double = 0
    
    var acceptEventMask: NSEvent.EventTypeMask{
        return value.waitEventMask 
    }
    var timeout: DispatchTime{
        return value.lastEventTime + value.waitTimeout
    }
    init(modifier: _ViewElementNode, view: _ViewElementNode){
        self.modifier = modifier
        self.view = view
    }
    static var current: _GestureContextValue? = nil

    func fetchSelectID<T: Hashable>(_ value: inout T?){
        
        if let id = view.node.id{
            print("name \(view.node.name) \(id.base) \(T.self)")
            value = id.base as? T
            return
        }
        _ = view.modifiers.last{
            let tag = $0.node.traits[TagValueTraitKey<T>.self]
            switch tag{
                case let .tagged(t): 
                    value = t
                    return true
                default: break
            }
            return false
        }
    }
    func processEvent(_ event: NSEvent){
        Self.current = self
        defer{
            Self.current = nil
        }

        value.waitEventMask = .none
        value.valueChanged = false

        if let process = modifier.node.any as? _EventProcess{
            process.processEvent(event, node: self)
        }
        value.lastEventTime = .now()
        if event.type == .timeout{
            value.waitEventMask = .none
        }
    }
}

protocol _DefaultGestureEventProcess : _EventProcess, _ViewElementNodeCreator{
    associatedtype T : Gesture
    var gesture: T {get}
    var gestureMask: GestureMask {get}

    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue)
    func gestureContextInit(value: inout _GestureContextValue)
}
extension _DefaultGestureEventProcess{
    func processEvent(_ event: NSEvent, node: _GestureContextValue) {
        doProcessEvent(event, node: node)
    }
    func doProcessEvent(_ event: NSEvent, node: _GestureContextValue) {
        processEvent(event, value: node.value, node: node)
    }
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue){
        doProcessEvent(event, value: value, node: node)
    }
    func doProcessEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        if let process = gesture as? _GestureProcess {
            process.processEvent(event, value: value, node: node)
        }
    }
}


extension ModifierGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        if let process = content as? _GestureProcess {
            process.processEvent(event, value: value, node: node)
        }
    }
}
extension GestureStateGesture: _GestureProcess {
    func processEvent(_ event: NSEvent, value: _GestureValue, node: _GestureContextValue) {
        if let process = base as? _GestureProcess {
            process.processEvent(event, value: value, node: node)
            if value.valueChanged {
                var stateValue: State {
                    get { return state.wrappedValue }
                    set { state.state.wrappedValue = newValue }
                }
                closure(value.value as! Value, &stateValue, &value.transaction)
            }
        }
    }
}

