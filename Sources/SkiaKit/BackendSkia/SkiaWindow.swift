
@_cdecl("SwiftSkiaWindowOnClose")
func SwiftSkiaWindowOnClose(_ w: UnsafeMutableRawPointer){
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    DispatchQueue.main.async{
        window.performClose()
    }
}
@_cdecl("SwiftSkiaWindowOnMouse")
func SwiftSkiaWindowOnMouse(_ w: UnsafeMutableRawPointer, point: ScPoint, state: SC.InputState, modifier: SC.ModifierKey){
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    let event = NSEvent.init()
    event.type = state.toEventType()
    event.modifierFlags = modifier.toEventModifierFlags()
    let mousePoint = point.toCGPoint()
    event.locationInWindow = mousePoint
    event.window = window
    //let mosueLocation =  nsevent.locationInWindow.offset(point: .init(x: -transPoint.x,y: -transPoint.y))
    // print("mouse \(event) \(event.locationInWindow) \(modifier)")
    NSApplication.shared.sendEvent(event)
}
@_cdecl("SwiftSkiaWindowOnKey")
func SwiftSkiaWindowOnKey(_ w: UnsafeMutableRawPointer, key: SC.Key, state: SC.InputState, modifier: SC.ModifierKey) -> Bool{
    print("on key \(key) \(state) \(modifier)")
    return false
}
@_cdecl("SwiftSkiaWindowOnChar")
func SwiftSkiaWindowOnChar(_ w: UnsafeMutableRawPointer, code: SkUnichar, modifier: SC.ModifierKey) -> Bool{
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    print("get char \(code) \(modifier) \(window)")
    return true
}
@_cdecl("SwiftSkiaWindowOnResize")
func SwiftSkiaWindowOnResize(_ w: UnsafeMutableRawPointer, size: ScSize){
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    window.windowDidResize()
}

@_cdecl("SwiftSkiaWindowOnPaint")
func SwiftSkiaWindowOnPaint(_ w: UnsafeMutableRawPointer, context: UnsafeMutablePointer<ScContext>){
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    let ctx = CGContext.init(context.pointee)
    let nsctx = NSGraphicsContext.init(ctx)

    window.windowDrawWithCtx(nsctx)
}
@_cdecl("SwiftSkiaWindowOnMouseWheel")
func SwiftSkiaWindowOnMouseWheel(_ w: UnsafeMutableRawPointer, point: ScPoint, delta: ScSize, modifier: SC.ModifierKey) -> Bool{
    let window: NSWindow = CXXSwiftInterop.shared.cxx_pointer_to_swift_object(w)
    let event = NSEvent.init()
    event.type = .scrollWheel
    event.modifierFlags = modifier.toEventModifierFlags()

    let deltaSize = delta.toCGSize()
    event.deltaX = deltaSize.width
    event.deltaY = deltaSize.height

    let mousePoint = point.toCGPoint()
    event.locationInWindow = mousePoint
    event.window = window
    // print("SwiftSkiaWindowOnMouseWheel \(event.deltaY) \(event.locationInWindow)")
    NSApplication.shared.sendEvent(event)
    return true
}
