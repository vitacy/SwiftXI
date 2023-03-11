class SwiftUIWindow: NSWindow {
    var eventTrackers: [_EventTracker] = .init()
    var _renderRoot: _StackViewElementNode? = nil
    var gestureValues = [_GestureContextValue].init()
    override init(){super.init()}

    var nodeSize: CGSize{
        guard let geometry =  _renderRoot?.geometry else{
            return .zero
        }
        return geometry.bounds.size
    }
    var nodeMinSize: CGSize{
        return _renderRoot?.sizeThatFits(.zero) ?? .zero
    }
    var nodeMaxSize: CGSize{
        return _renderRoot?.sizeThatFits(.infinity) ?? .zero
    }
    var contentRoot: _StackViewElementNode? {
        get { return _renderRoot }
        set {
            _renderRoot = newValue
            _renderRoot?.node.scene?.window = self
            layoutWindowNode()
        }
    }
    func windowNeedRedraw(){
        viewsNeedDisplay = true
    }
    func layoutWindowNode() {
        if let node = _renderRoot {            
            node.layout(size: self.contentRect.size)
            let nodeSize = node.geometry.bounds.size
            self.setContentSize(nodeSize)            
            windowNeedRedraw()
        }
    }
    override func windowDidResize(){
        if let node = _renderRoot {
            let contentSize = self.contentRect.size
            node.layout(size: contentSize)
        }
    }

    override func sendEvent(_ event: NSEvent) {
        event.window = self
        let eventmask: NSEvent.EventTypeMask = .init(eventType: event.type)
        let trackers = eventTrackers
        for tracker in trackers{
            if tracker.mask.contains(eventmask) {
                tracker.body(event, &tracker.done)
            }else if tracker.until < .now(){
                tracker.body(.init(.timeout), &tracker.done)
            }
        }
        eventTrackers = eventTrackers.filter{ return !$0.done}

        if event.type == .mouseMoved{
            return
        }
        
        if [.leftMouseDown, .rightMouseDown].contains(eventmask) && event.clickCount == 1{
            gestureValues = _renderRoot?.hitTestGesture(event.locationInWindow) ?? []
        }
        for gesture in gestureValues{
            if (gesture.timeout < .now()){
                gesture.processEvent(.init(.timeout))
            }else if !event.consumed && gesture.acceptEventMask.contains(eventmask){
                gesture.processEvent(event)
            }
        }
        
        event.window = nil

        gestureValues = gestureValues.filter{ $0.acceptEventMask != .none}
        if [.leftMouseUp, .rightMouseUp].contains(event.type) {
            gestureValues = gestureValues.filter{ $0.acceptEventMask.contains(eventmask) }
        }
    }
    func trackEvent(matching mask: NSEvent.EventTypeMask, until expiration: DispatchTime, body: @escaping (NSEvent, inout Bool) -> Void) {
        let tracker = _EventTracker.init(mask: mask, until: expiration, body: body)
        self.eventTrackers.append(tracker)
    }
    override func drawContext(size: CGSize) {
        if let node = _renderRoot {
            let layout = node.geometry
            let nodeSize = CGSize.init(width: layout.width, height: layout.height)
            if nodeSize != size {
                let offset = CGSize.init(width: (size.width - nodeSize.width) * 0.5, height: (size.height - nodeSize.height) * 0.5)
                let trans = CGAffineTransform.init(translationX: offset.width.rounded(), y: offset.height.rounded())
                trans.concat()
            }
            node.drawContext()
        }
    }
}

class _EventTracker {
    let owner: AnyObject?
    let mask: NSEvent.EventTypeMask
    let until: DispatchTime
    let body: (NSEvent, inout Bool) -> Void
    var done = false
    init(owner: AnyObject? = nil, mask: NSEvent.EventTypeMask, until: DispatchTime, body: @escaping  (NSEvent, inout Bool) -> Void){
        self.owner = owner
        self.mask = mask
        self.until = until
        self.body = body
    }
}
