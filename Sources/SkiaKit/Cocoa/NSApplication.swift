
public typealias UIApplicationDelegate = NSApplicationDelegate
public typealias UIApplication = NSApplication

public final class NSApplication {
    public static let shared = NSApplication.init()
    public var delegate: NSApplicationDelegate? = nil
    public var windows = [NSWindow].init()

    public func run() {
        SkiaApp.shared.start()
    }
    public func quit(){
        SkiaApp.shared.stop()
    }
    public func sendEvent(_ event: NSEvent) {
        _EventLoop.shared.processEvent(event)
        event.window?.sendEvent(event)
    }
}

extension NSApplication{
    public enum TerminateReply : UInt {
        case terminateCancel = 0
        case terminateNow = 1
        case terminateLater = 2
    }
}

public protocol NSApplicationDelegate{
    func applicationWillFinishLaunching(_ notification: Notification)
    func applicationDidFinishLaunching(_ notification: Notification)
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply
    func applicationWillTerminate(_ notification: Notification)

    func applicationDidFinishLaunching(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillTerminate(_ application: UIApplication)
}

extension NSApplicationDelegate{
    public func applicationWillFinishLaunching(_ notification: Notification){

    }
    public func applicationDidFinishLaunching(_ notification: Notification){

    }
    public func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply{
        return .terminateNow
    }
    public func applicationWillTerminate(_ notification: Notification){

    }

    public func applicationDidFinishLaunching(_ application: UIApplication){

    }
    public func applicationDidBecomeActive(_ application: UIApplication){

    }
    public func applicationWillTerminate(_ application: UIApplication){

    }
}


final class _EventLoop {
    var mouseLocation = CGPoint.zero
    var modifierFlags = NSEvent.ModifierFlags.empty
    var pressedMouseButtons = 0
    var leftMouseClickCount = 0
    var leftMouseClickCountLastTime: TimeInterval = 0
    var lastEventTime: TimeInterval = 0
    static let shared = _EventLoop.init()
    func processEvent(_ event: NSEvent) {
        lastEventTime = event.timestamp
        switch event.type {
        case .mouseMoved:
            mouseLocation = event.locationInWindow
            if (pressedMouseButtons & 1) > 0 {
                event.type = .leftMouseDragged
            }
            self.updateLeftMouseClickCountByTime(event)
        case .leftMouseDown:
            self.updateLeftMouseClickCount(event)
            leftMouseClickCount += 1

            mouseLocation = event.locationInWindow
            pressedMouseButtons = (pressedMouseButtons | 1)
        case .leftMouseUp:
            self.updateLeftMouseClickCount(event)

            mouseLocation = event.locationInWindow
            pressedMouseButtons = (pressedMouseButtons & (~1))
        case .leftMouseDragged:
            mouseLocation = event.locationInWindow
            self.updateLeftMouseClickCountByTime(event)
        default: break
        }

        event.clickCount = leftMouseClickCount
    }
    func clearLeftMouseClickCount() {
        leftMouseClickCount = 0
    }
    func updateLeftMouseClickCountByTime(_ event: NSEvent) {
        if leftMouseClickCount > 0 && event.timestamp - leftMouseClickCountLastTime > NSEvent.doubleClickInterval {
            leftMouseClickCount = 0
        }
    }
    func updateLeftMouseClickCount(_ event: NSEvent) {
        updateLeftMouseClickCountByTime(event)
        leftMouseClickCountLastTime = event.timestamp
    }
}
