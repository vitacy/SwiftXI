
//, NSCopying, NSSecureCoding
public typealias UIBezierPath = NSBezierPath
public class NSBezierPath : NSObject {
    var _path: CGMutablePath = .init()
    var _fill: FillStyle = .init()
    var _stroke: StrokeStyle = .init()

    public override init(){
        super.init()
    }
    public init(rect: NSRect){
        super.init()
        _path.addRect(rect)
    }
    public init(ovalIn rect: NSRect){
        _path.addEllipse(in: rect)
    }
    public init(roundedRect rect: NSRect, xRadius: CGFloat, yRadius: CGFloat){
        _path.addRoundedRect(in: rect, cornerWidth: xRadius, cornerHeight: yRadius)
    }
    open class func fill(_ rect: NSRect){
        NSBezierPath.init(rect: rect).fill()
    }
    open class func stroke(_ rect: NSRect){
        NSBezierPath.init(rect: rect).stroke()
    }
    open class func clip(_ rect: NSRect){
        NSBezierPath.init(rect: rect).addClip()
    }
    open class func strokeLine(from point1: NSPoint, to point2: NSPoint){
        let path = NSBezierPath.init()
        path.move(to: point1)
        path.line(to: point2)
        path.stroke()
    }
    // open class func drawPackedGlyphs(_ packedGlyphs: UnsafePointer<CChar>, at point: NSPoint)

    // open class var defaultMiterLimit: CGFloat
    // open class var defaultFlatness: CGFloat
    // open class var defaultWindingRule: NSBezierPath.WindingRule
    // open class var defaultLineCapStyle: NSBezierPath.LineCapStyle
    // open class var defaultLineJoinStyle: NSBezierPath.LineJoinStyle
    // open class var defaultLineWidth: CGFloat

    open func move(to point: NSPoint){
        _path.move(to: point)
    }
    open func line(to point: NSPoint){
        _path.addLine(to: point)
    }
    open func curve(to endPoint: NSPoint, controlPoint1: NSPoint, controlPoint2: NSPoint){
        _path.addCurve(to:endPoint, control1: controlPoint1, control2: controlPoint2)
    }
    open func close(){
        _path.closeSubpath()
    }
    
    open func removeAllPoints(){
        _path = .init()
    }

    open func relativeMove(to point: NSPoint){

    }
    open func relativeLine(to point: NSPoint){

    }
    open func relativeCurve(to endPoint: NSPoint, controlPoint1: NSPoint, controlPoint2: NSPoint){

    }

    // open var lineWidth: CGFloat {
    // }
    // open var lineCapStyle: NSBezierPath.LineCapStyle
    // open var lineJoinStyle: NSBezierPath.LineJoinStyle
    // open var windingRule: NSBezierPath.WindingRule
    // open var miterLimit: CGFloat
    // open var flatness: CGFloat
    // open func getLineDash(_ pattern: UnsafeMutablePointer<CGFloat>?, count: UnsafeMutablePointer<Int>?, phase: UnsafeMutablePointer<CGFloat>?)
    // open func setLineDash(_ pattern: UnsafePointer<CGFloat>?, count: Int, phase: CGFloat)

    
    open func stroke(){

    }
    open func fill(){

    }
    open func addClip(){

    }
    open func setClip(){

    }

    // @NSCopying open var flattened: NSBezierPath { get }
    // @NSCopying open var reversed: NSBezierPath { get }

    open func transform(using transform: AffineTransform){

    }

    // open var isEmpty: Bool { get }
    // open var currentPoint: NSPoint { get }
    // open var controlPointBounds: NSRect { get }
    // open var bounds: NSRect { get }
    // open var elementCount: Int { get }
    // open func element(at index: Int, associatedPoints points: NSPointArray?) -> NSBezierPath.ElementType
    // open func element(at index: Int) -> NSBezierPath.ElementType
    // open func setAssociatedPoints(_ points: NSPointArray?, at index: Int)
    // open func append(_ path: NSBezierPath)
    // open func appendRect(_ rect: NSRect)
    // open func appendPoints(_ points: NSPointArray, count: Int)
    // open func appendOval(in rect: NSRect)
    // open func appendArc(withCenter center: NSPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
    // open func appendArc(withCenter center: NSPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    // open func appendArc(from point1: NSPoint, to point2: NSPoint, radius: CGFloat)
    // open func append(withCGGlyph glyph: CGGlyph, in font: NSFont)
    // open func append(withCGGlyphs glyphs: UnsafePointer<CGGlyph>, count: Int, in font: NSFont)
    // open func appendRoundedRect(_ rect: NSRect, xRadius: CGFloat, yRadius: CGFloat)

    // open func contains(_ point: NSPoint) -> Bool
}

public struct FillStyle: Equatable {
    public var isEOFilled: Bool
    public var isAntialiased: Bool
    public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}
public struct StrokeStyle: Equatable {
    public var lineWidth: CGFloat = 1
    public var lineCap: CGLineCap = .butt
    public var lineJoin: CGLineJoin = .miter
    public var miterLimit: CGFloat = 10
    public var dash: [CGFloat] = .init()
    public var dashPhase: CGFloat = 0
    public init(lineWidth: CGFloat = 1, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10, dash: [CGFloat] = [CGFloat](), dashPhase: CGFloat = 0){
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}