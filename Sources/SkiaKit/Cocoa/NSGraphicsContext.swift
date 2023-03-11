public final class NSGraphicsContext: NSObject {
    let _internal: CGContext
    init(_ ctx: CGContext) {
        _internal = ctx
    }
    public static var current: NSGraphicsContext? = nil

    public class func saveGraphicsState() {
        let ctx = self.current
        ctx?.saveGraphicsState()
        _graphicsContextList.append(ctx)
    }
    public class func restoreGraphicsState() {
        Self.current = _graphicsContextList.removeLast()
        Self.current?.restoreGraphicsState()
    }
    public func saveGraphicsState() {
       _internal.saveGState()
    }
    public func restoreGraphicsState() {
        _internal.restoreGState()
    }
}
public func UIGraphicsGetCurrentContext() -> CGContext?{
    return NSGraphicsContext.current?.cgContext
}
public func UIGraphicsPushContext(_ context: CGContext){
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = .init(context)
}
public func UIGraphicsPopContext(){
    NSGraphicsContext.restoreGraphicsState()
}
class BoxWrapper<T>: NSObject{
    var value: T
    init(wrappedValue: T){
        self.value = wrappedValue
    }
}
extension NSGraphicsContext {
    struct _GraphicsContextThreadKey {
        typealias Value = [NSGraphicsContext?]
        static var defaultValue: Value {
            return .init()
        }
    }
    
    static var _graphicsContextList: _GraphicsContextThreadKey.Value{
        get {
            let key = ObjectIdentifier(_GraphicsContextThreadKey.self)
            let saved = Thread.current.threadDictionary.object(forKey: key) as? BoxWrapper<_GraphicsContextThreadKey.Value>
            let list = saved?.value ?? _GraphicsContextThreadKey.defaultValue
            return list
        }
        set {
            let key = ObjectIdentifier(_GraphicsContextThreadKey.self)
            Thread.current.threadDictionary.setObject(BoxWrapper.init(wrappedValue: newValue), forKey: key)
        }
    }
}
extension NSGraphicsContext{
    public var cgContext: CGContext{
        return _internal
    }
}

extension CGAffineTransform {
    public func concat() {
        NSGraphicsContext.current?.cgContext.concatenate(self)
    }
}

extension NSImage{
    public func draw(in rect: CGRect, from fromRect: CGRect, operation op: NSCompositingOperation, fraction delta: CGFloat){
        self.draw(in: rect, blendMode: .normal, alpha: delta)
    }
    public func draw(at point: CGPoint){
        self.draw(in: CGRect.init(origin: point, size: self.size))
    }
    public func draw(at point: CGPoint, blendMode: CGBlendMode, alpha: CGFloat){
        self.draw(in: CGRect.init(origin: point, size: self.size), blendMode: blendMode, alpha: alpha)
    }

    public func draw(in rect: CGRect){
        self.draw(in: rect, blendMode: .normal, alpha: 1.0)
    }

    public func draw(in rect: CGRect, blendMode: CGBlendMode, alpha: CGFloat){
        NSGraphicsContext.current?.cgContext.drawImage(self, in: rect, blendMode: blendMode, alpha: alpha)
    }
}


extension NSColor{
    public func set(){
        NSGraphicsContext.current?.cgContext.setFillColor(self)
        NSGraphicsContext.current?.cgContext.setStrokeColor(self)
    }
}