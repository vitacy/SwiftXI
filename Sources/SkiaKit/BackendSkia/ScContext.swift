import SkiaKitCxx

@_expose(Cxx)
public struct _ScAffineTransform{
    var ctm: CGAffineTransform = .init()
    public init(){}
}

extension ScPaint{
    public mutating func setColor(_ color: CGColor){
      let srgb = color.toSRGBColor()
      self.setColor(srgb.red, srgb.green, srgb.blue, srgb.opacity)
    }
}
extension CGContext{
    public func strokePath<T: _PathConvertible>(convertible path: T, style: StrokeStyle = .init()){
        var paint = ScPaint.init()
        paint.setColor(_strokeColor.withAlphaComponent(_alpha))
        paint.setStroke(true)
        paint.setAntiAlias(true)

        var scpath = ScPath.init()
        scpath.addPath(path)
        _scContext.drawPath(scpath, paint)
    }
    public func fillPath<T: _PathConvertible>(convertible path: T, style: FillStyle = .init()){
        var paint = ScPaint.init()
        paint.setColor(_fillColor.withAlphaComponent(_alpha))
        paint.setStroke(false)
        paint.setAntiAlias(true)

        var scpath = ScPath.init()
        scpath.addPath(path)
        _scContext.drawPath(scpath, paint)
    }
    public func clipPath<T: _PathConvertible>(convertible path: T){
        var scpath = ScPath.init()
        scpath.addPath(path)
        _scContext.clipPath(scpath, true)
    }
    func drawGlyphs(_ count: Int, glyphs: Array<SkGlyphID>, positions: Array<ScPoint>, origin: ScPoint, font: NSFont){
        var paint=ScPaint.init()
        paint.setColor(_fillColor.withAlphaComponent(_alpha))
        paint.setStroke(false)
        paint.setAntiAlias(true)
        _scContext.drawGlyphs(Int32(count), glyphs, positions, origin, font._internal, paint)
    }
    func drawImage(_ image: NSImage, in rect: CGRect, blendMode: CGBlendMode, alpha: CGFloat){
        guard let rep = image.representations.first else{
            return
        }
        if let scimage = rep as? ScImage{
            _scContext.drawImage(scimage, rect.toSkRect());
        }
    }
}
extension ScPath{
    mutating func addPath<P: _PathConvertible>(_ path: P){
        path.forEach { e in
            switch e {
            case let .move(to: p): self.moveTo(SkScalar(p.x), SkScalar(p.y))
            case let .line(to: p): self.lineTo(SkScalar(p.x), SkScalar(p.y))
            case let .quadCurve(to: to, control: cp):
                self.quadTo(cp.toSkPoint(), to.toSkPoint())
            case let .curve(to: to, control1: cp1, control2: cp2):
                self.cubicTo(cp1.toSkPoint(), cp2.toSkPoint(), to.toSkPoint())
                break
            case .closeSubpath: self.close()
            }
        }
    }
}
public protocol _PathConvertible{
    func forEach(_ body: (CGPath.Element) -> Void)
}

extension CGPath: _PathConvertible{
}

typealias SkUnichar = SkiaKitCxx.SkUnichar
typealias SkScalar = SkiaKitCxx.SkScalar
typealias ScFloat = SkiaKitCxx.ScFloat
typealias SkGlyphID = SkiaKitCxx.SkGlyphID
typealias ScString = SkiaKitCxx.ScString
typealias ScPoint = SkiaKitCxx.ScPoint
typealias ScSize = SkiaKitCxx.ScSize
typealias ScRect = SkiaKitCxx.ScRect
typealias SC = SkiaKitCxx.SC

typealias ScContext = SkiaKitCxx.ScContext
typealias ScFont = SkiaKitCxx.ScFont
typealias ScWindow = SkiaKitCxx.ScWindow
typealias ScPaint = SkiaKitCxx.ScPaint
typealias ScData = SkiaKitCxx.ScData
typealias ScBitmap = SkiaKitCxx.ScBitmap
typealias ScImage = SkiaKitCxx.ScImage
typealias ScImageInfo = SkiaKitCxx.ScImageInfo
typealias ScColorType = SkiaKitCxx.ScColorType
typealias ScAlphaType = SkiaKitCxx.ScAlphaType
typealias ScFontStyle = SkiaKitCxx.ScFontStyle



