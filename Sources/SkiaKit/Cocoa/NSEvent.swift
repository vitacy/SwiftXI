public class NSEvent: NSObject {
    public var type: NSEvent.EventType = .none
    public var timestamp: TimeInterval = 0
    public var modifierFlags: NSEvent.ModifierFlags = .empty
    public weak var window: NSWindow? = nil
    public var clickCount: Int = 0
    public var buttonNumber: Int = 0
    public var eventNumber: Int = 0
    public var locationInWindow: NSPoint = .zero
    public var keyCode: Int = 0
    public var deltaX: CGFloat = 0
    public var deltaY: CGFloat = 0
    public var consumed = false

    public static var doubleClickInterval: TimeInterval { 0.5 }

    public init(_ type: NSEvent.EventType = .none) {
        self.type = type
        self.timestamp = Date.timeIntervalSinceReferenceDate
    }
}

extension NSEvent {
    public enum Button: UInt {
        case left = 1
        case right = 2
        case other = 3
    }
    public enum EventType: UInt64 {
        case none = 0
        case leftMouseDown = 1
        case leftMouseUp = 2
        case rightMouseDown = 3
        case rightMouseUp = 4
        case mouseMoved = 5
        case leftMouseDragged = 6
        case rightMouseDragged = 7
        case mouseEntered = 8
        case mouseExited = 9
        case keyDown = 10
        case keyUp = 11
        case flagsChanged = 12
        case appKitDefined = 13
        case systemDefined = 14
        case applicationDefined = 15
        case periodic = 16
        case cursorUpdate = 17
        case scrollWheel = 22
        case tabletPoint = 23
        case tabletProximity = 24
        case otherMouseDown = 25
        case otherMouseUp = 26
        case otherMouseDragged = 27
        case gesture = 29
        case magnify = 30
        case swipe = 31
        case rotate = 18
        case beginGesture = 19
        case endGesture = 20
        case smartMagnify = 32
        case quickLook = 33
        case pressure = 34
        case directTouch = 37
        case changeMode = 38

        case timeout = 60
    }

    public struct ModifierFlags: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        public static var empty: NSEvent.ModifierFlags { .init(rawValue: 0) }
        public static var capsLock: NSEvent.ModifierFlags { .init(rawValue: 1 << 0) }
        public static var shift: NSEvent.ModifierFlags { .init(rawValue: 1 << 1) }
        public static var control: NSEvent.ModifierFlags { .init(rawValue: 1 << 2) }
        public static var option: NSEvent.ModifierFlags { .init(rawValue: 1 << 3) }
        public static var command: NSEvent.ModifierFlags { .init(rawValue: 1 << 4) }
        public static var numericPad: NSEvent.ModifierFlags { .init(rawValue: 1 << 5) }
        public static var function: NSEvent.ModifierFlags { .init(rawValue: 1 << 6) }
    }

    public struct EventTypeMask: OptionSet {
        public let rawValue: UInt64
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }

        public static var none: NSEvent.EventTypeMask { .init(eventType: .none) }
        public static var leftMouseDown: NSEvent.EventTypeMask { .init(eventType: .leftMouseDown) }
        public static var leftMouseUp: NSEvent.EventTypeMask { .init(eventType: .leftMouseUp) }
        public static var rightMouseDown: NSEvent.EventTypeMask { .init(eventType: .rightMouseDown) }
        public static var rightMouseUp: NSEvent.EventTypeMask { .init(eventType: .rightMouseUp) }
        public static var mouseMoved: NSEvent.EventTypeMask { .init(eventType: .mouseMoved) }
        public static var leftMouseDragged: NSEvent.EventTypeMask { .init(eventType: .leftMouseDragged) }
        public static var rightMouseDragged: NSEvent.EventTypeMask { .init(eventType: .rightMouseDragged) }
        public static var mouseEntered: NSEvent.EventTypeMask { .init(eventType: .mouseEntered) }
        public static var mouseExited: NSEvent.EventTypeMask { .init(eventType: .mouseExited) }
        public static var keyDown: NSEvent.EventTypeMask { .init(eventType: .keyDown) }
        public static var keyUp: NSEvent.EventTypeMask { .init(eventType: .keyUp) }
        public static var flagsChanged: NSEvent.EventTypeMask { .init(eventType: .flagsChanged) }
        public static var appKitDefined: NSEvent.EventTypeMask { .init(eventType: .appKitDefined) }
        public static var systemDefined: NSEvent.EventTypeMask { .init(eventType: .systemDefined) }
        public static var applicationDefined: NSEvent.EventTypeMask { .init(eventType: .applicationDefined) }
        public static var periodic: NSEvent.EventTypeMask { .init(eventType: .periodic) }
        public static var cursorUpdate: NSEvent.EventTypeMask { .init(eventType: .cursorUpdate) }
        public static var scrollWheel: NSEvent.EventTypeMask { .init(eventType: .scrollWheel) }
        static var tabletPoint: NSEvent.EventTypeMask { .init(eventType: .tabletPoint) }
        static var tabletProximity: NSEvent.EventTypeMask { .init(eventType: .tabletProximity) }
        static var otherMouseDown: NSEvent.EventTypeMask { .init(eventType: .otherMouseDown) }
        static var otherMouseUp: NSEvent.EventTypeMask { .init(eventType: .otherMouseUp) }
        static var otherMouseDragged: NSEvent.EventTypeMask { .init(eventType: .otherMouseDragged) }
        static var gesture: NSEvent.EventTypeMask { .init(eventType: .gesture) }
        static var magnify: NSEvent.EventTypeMask { .init(eventType: .magnify) }
        static var swipe: NSEvent.EventTypeMask { .init(eventType: .swipe) }
        static var rotate: NSEvent.EventTypeMask { .init(eventType: .rotate) }
        static var beginGesture: NSEvent.EventTypeMask { .init(eventType: .beginGesture) }
        static var endGesture: NSEvent.EventTypeMask { .init(eventType: .endGesture) }
        static var smartMagnify: NSEvent.EventTypeMask { .init(eventType: .smartMagnify) }
        static var quickLook: NSEvent.EventTypeMask { .init(eventType: .quickLook) }
        static var pressure: NSEvent.EventTypeMask { .init(eventType: .pressure) }
        static var directTouch: NSEvent.EventTypeMask { .init(eventType: .directTouch) }
        static var changeMode: NSEvent.EventTypeMask { .init(eventType: .changeMode) }
        public static var timeout: NSEvent.EventTypeMask { .init(eventType: .timeout) }

        public static var any: NSEvent.EventTypeMask { .init(rawValue: Self.RawValue.max) }
    }
}

extension NSEvent.EventTypeMask {
    public init(eventType: NSEvent.EventType) {
        self.init(rawValue: 1 << eventType.rawValue)
    }
}
