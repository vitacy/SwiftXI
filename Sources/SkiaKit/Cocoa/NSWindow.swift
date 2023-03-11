

open class NSWindow: NSObject{
    var _internal: ScWindow

    public override init(){
        let window = ScWindow.init()
        _internal = window
        super.init()
        NSApplication.shared.windows.append(self)

        let w = CXXSwiftInterop.shared.cxx_pointer_from_swift_object(self)
        _internal.setSwiftWindow(w)
    }
    private init(_ window: ScWindow) {
        _internal = window
        super.init()
        NSApplication.shared.windows.append(self)
        
        let w = CXXSwiftInterop.shared.cxx_pointer_from_swift_object(self)
        _internal.setSwiftWindow(w)
    }
    open var title: String {
        get { 
            var str = ScString.init()
            _internal.getTitle(&str) 
            return str.toString()
        }
        set { _internal.setTitle(newValue.toSkString()) }
    }
    var size: CGSize {
        get {
            var value = ScSize.MakeEmpty()
            _internal.getSize(&value) 
            return value.toCGSize()
        }
        set {_internal.setSize(newValue.toSkSize())}
    }
    open var contentRect: CGRect{
        var value = ScRect.MakeEmpty()
        _internal.getContentRect(&value) 
        return value.toCGRect()
    }
    open var frame: CGRect { 
        var value = ScPoint.MakeEmpty()
        _internal.getPosition(&value) 
        return .init(origin: value.toCGPoint(), size: self.size)
    }
    open func setFrame(_ frameRect: CGRect, display displayFlag: Bool, animate animateFlag: Bool = false){
        self.setFrameOrigin(frameRect.origin)
        self.size = frameRect.size
    }
    open func setContentSize(_ size: CGSize){
        let cRect = self.contentRect;
        self.size = size + self.size - cRect.size
    }

    open func setFrameOrigin(_ point: CGPoint){
        _internal.setPosition(point.toSkPoint())
    }
    
    open func sendEvent(_ event: NSEvent) {

    }
    open var viewsNeedDisplay: Bool = false{
        didSet{
            if (viewsNeedDisplay){
                DispatchQueue.main.async{[self] in
                    if (viewsNeedDisplay){
                        viewsNeedDisplay = false
                        _internal.inval()
                    }
                }
            }
        }
    }
    open func makeKeyAndOrderFront(_ sender: Any?) {
        _internal.show()
    }
    open func windowShouldClose() -> Bool{
        return true
    }
    open func windowWillClose(){
        print("windowWillClose")
    }
    open func performClose(){
        if windowShouldClose(){
            windowWillClose()
            close()
        }
    }
    open func close(){
        _internal.setSwiftWindow(nil)
        _internal.close()
    }
    open func drawContext(size: CGSize){
        
    }
    open func windowDidResize(){

    }
}

extension NSWindow{
    func windowDrawWithCtx(_ ctx: NSGraphicsContext){
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = ctx
        drawContext(size: self.contentRect.size)
        NSGraphicsContext.restoreGraphicsState()
    }
}