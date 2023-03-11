public class CGContext {
    var _scContext: ScContext
    var _path: CGMutablePath = .init()

    var _fill: FillStyle = .init()
    var _stroke: StrokeStyle = .init()
    var _fillColor: NSColor = .black;
    var _strokeColor: NSColor = .black;
    var _alpha: CGFloat = 1.0
    init(_ context: ScContext){
      _scContext = context
    }
}
public typealias CGGlyph = UInt32

extension CGContext{
  public func saveGState(){
    _scContext.save()
  }
  public func restoreGState(){
    _scContext.restore()
  }
  public func concatenate(_ transform: CGAffineTransform){
    let affine: [SkScalar] = [SkScalar(transform.m11),SkScalar(transform.m12),
        SkScalar(transform.m21),SkScalar(transform.m22),
        SkScalar(transform.tX),SkScalar(transform.tY)]

    _scContext.concatTransform(affine)
  }

  public func addPath(_ path: CGPath){
    _path.addPath(path)
  }
    // public var currentPointOfPath: CGPoint { get }
    // public var boundingBoxOfPath: CGRect { get }

    public var path: CGPath? { return nil }
    public func pathContains(_ point: CGPoint, mode: CGPathDrawingMode) -> Bool{
      return false
    }
    public func drawPath(using mode: CGPathDrawingMode){
      if mode == .stroke{
        strokePath(convertible: _path)
      }else{
        fillPath(convertible: _path)
      }
      _path = .init()
    }
    public func strokePath(){
      drawPath(using: .stroke)
    }
    public func resetClip(){

    }
    public func clip(to rect: CGRect, mask: CGImage){

    }
    public var boundingBoxOfClipPath: CGRect {
      return .zero
    }
    public func clip(to rect: CGRect){

    }
    public func setFillColor(_ color: CGColor){
      _fillColor = color
    }
    public func setStrokeColor(_ color: CGColor){
      _strokeColor = color;
    }
    // public var interpolationQuality: CGInterpolationQuality
    public func setShadow(offset: CGSize, blur: CGFloat, color: CGColor?){

    }
    public func setShadow(offset: CGSize, blur: CGFloat){

    }
    // public func drawLinearGradient(_ gradient: CGGradient, start startPoint: CGPoint, end endPoint: CGPoint, options: CGGradientDrawingOptions){
    // }
    // public func drawRadialGradient(_ gradient: CGGradient, startCenter: CGPoint, startRadius: CGFloat, endCenter: CGPoint, endRadius: CGFloat, options: CGGradientDrawingOptions){
    // }
    // public func drawShading(_ shading: CGShading){
    // }
    // public var textMatrix: CGAffineTransform
    // public func setTextDrawingMode(_ mode: CGTextDrawingMode){
    // }
    // public func drawPDFPage(_ page: CGPDFPage)
    // public func beginPage(mediaBox: UnsafePointer<CGRect>?)
    // public func endPage()

    public func flush(){

    }
    public func synchronize(){

    }
    public func setShouldAntialias(_ shouldAntialias: Bool){

    }
    public func setAllowsAntialiasing(_ allowsAntialiasing: Bool){

    }
}

extension CGContext{
  public func clip(using rule: CGPathFillRule = .winding){
    clipPath(convertible: _path)
    _path = .init()
  }
  public func setAlpha(_ alpha: CGFloat){
      _alpha = alpha
  }
}

public enum CGBlendMode : Int32 {
    case normal = 0

    case multiply = 1

    case screen = 2

    case overlay = 3

    case darken = 4

    case lighten = 5

    case colorDodge = 6

    case colorBurn = 7

    case softLight = 8

    case hardLight = 9

    case difference = 10

    case exclusion = 11

    case hue = 12

    case saturation = 13

    case color = 14

    case luminosity = 15

    
    /* Available in Mac OS X 10.5 & later. R, S, and D are, respectively,
           premultiplied result, source, and destination colors with alpha; Ra,
           Sa, and Da are the alpha components of these colors.
    
           The Porter-Duff "source over" mode is called `kCGBlendModeNormal':
             R = S + D*(1 - Sa)
    
           Note that the Porter-Duff "XOR" mode is only titularly related to the
           classical bitmap XOR operation (which is unsupported by
           CoreGraphics). */
    
    case clear = 16 /* R = 0 */

    case copy = 17 /* R = S */

    case sourceIn = 18 /* R = S*Da */

    case sourceOut = 19 /* R = S*(1 - Da) */

    case sourceAtop = 20 /* R = S*Da + D*(1 - Sa) */

    case destinationOver = 21 /* R = S*(1 - Da) + D */

    case destinationIn = 22 /* R = D*Sa */

    case destinationOut = 23 /* R = D*(1 - Sa) */

    case destinationAtop = 24 /* R = S*(1 - Da) + D*Sa */

    case xor = 25 /* R = S*(1 - Da) + D*(1 - Sa) */

    case plusDarker = 26 /* R = MAX(0, (1 - D) + (1 - S)) */

    case plusLighter = 27 /* R = MIN(1, S + D) */
}

public enum NSCompositingOperation : UInt {
    case clear = 0

    case copy = 1

    case sourceOver = 2

    case sourceIn = 3

    case sourceOut = 4

    case sourceAtop = 5

    case destinationOver = 6

    case destinationIn = 7

    case destinationOut = 8

    case destinationAtop = 9

    case xor = 10

    case plusDarker = 11
    
    case plusLighter = 13
}

public enum CGPathDrawingMode : Int32 {

    
    case fill = 0

    case eoFill = 1

    case stroke = 2

    case fillStroke = 3

    case eoFillStroke = 4
}