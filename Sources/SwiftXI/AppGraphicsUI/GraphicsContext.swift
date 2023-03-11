public struct GraphicsContext {
    public struct BlendMode : RawRepresentable, Equatable {
        public let rawValue: Int32
        public init(rawValue: Int32){
            self.rawValue = rawValue
        }
        @usableFromInline init(_ blendMode: CGBlendMode){
            self.rawValue = blendMode.rawValue
        }

        @inlinable public static var normal: GraphicsContext.BlendMode { .init(.normal) }
        @inlinable public static var multiply: GraphicsContext.BlendMode { .init(.multiply)  }
        @inlinable public static var screen: GraphicsContext.BlendMode { .init(.screen)  }
        @inlinable public static var overlay: GraphicsContext.BlendMode { .init(.overlay)  }
        @inlinable public static var darken: GraphicsContext.BlendMode { .init(.darken)  }
        @inlinable public static var lighten: GraphicsContext.BlendMode { .init(.lighten)  }
        @inlinable public static var colorDodge: GraphicsContext.BlendMode { .init(.colorDodge) }
        @inlinable public static var colorBurn: GraphicsContext.BlendMode { .init(.colorBurn) }
        @inlinable public static var softLight: GraphicsContext.BlendMode { .init(.softLight) }
        @inlinable public static var hardLight: GraphicsContext.BlendMode { .init(.hardLight) }
        @inlinable public static var difference: GraphicsContext.BlendMode { .init(.difference) }
        @inlinable public static var exclusion: GraphicsContext.BlendMode { .init(.exclusion) }
        @inlinable public static var hue: GraphicsContext.BlendMode { .init(.hue) }
        @inlinable public static var saturation: GraphicsContext.BlendMode { .init(.saturation) }
        @inlinable public static var color: GraphicsContext.BlendMode { .init(.color) }
        @inlinable public static var luminosity: GraphicsContext.BlendMode { .init(.luminosity) }
        @inlinable public static var clear: GraphicsContext.BlendMode { .init(.clear) }
        @inlinable public static var copy: GraphicsContext.BlendMode { .init(.copy) }
        @inlinable public static var sourceIn: GraphicsContext.BlendMode { .init(.sourceIn) }
        @inlinable public static var sourceOut: GraphicsContext.BlendMode { .init(.sourceOut) }
        @inlinable public static var sourceAtop: GraphicsContext.BlendMode { .init(.sourceAtop) }
        @inlinable public static var destinationOver: GraphicsContext.BlendMode { .init(.destinationOver) }
        @inlinable public static var destinationIn: GraphicsContext.BlendMode { .init(.destinationIn) }
        @inlinable public static var destinationOut: GraphicsContext.BlendMode { .init(.destinationOut) }
        @inlinable public static var destinationAtop: GraphicsContext.BlendMode { .init(.destinationAtop) }
        @inlinable public static var xor: GraphicsContext.BlendMode { .init(.xor) }
        @inlinable public static var plusDarker: GraphicsContext.BlendMode { .init(.plusDarker) }
        @inlinable public static var plusLighter: GraphicsContext.BlendMode { .init(.plusLighter) }

        public typealias RawValue = Int32
    }

    public var opacity: Double = 1 
    public var blendMode: GraphicsContext.BlendMode = .normal
    public var environment: EnvironmentValues = .init()
    public var transform: CGAffineTransform = .init()

    var _context: CGContext 
    init(_ context: CGContext){
      _context = context
    }
    public mutating func scaleBy(x: CGFloat, y: CGFloat){
        transform = transform.scaledBy(x: x, y: y)
    }
    public mutating func translateBy(x: CGFloat, y: CGFloat){
        transform = transform.translatedBy(x: x, y: y)
    }
    public mutating func rotate(by angle: Angle){
        transform = transform.rotated(by: angle.degrees)
    }
    public mutating func concatenate(_ matrix: CGAffineTransform){
        transform = transform.concatenating(matrix)
    }


    public struct ClipOptions : OptionSet {
        public let rawValue: UInt32
        @inlinable public init(rawValue: UInt32){
            self.rawValue = rawValue
        }
        @inlinable public static var inverse: GraphicsContext.ClipOptions { .init(rawValue: 1) }

        public typealias ArrayLiteralElement = GraphicsContext.ClipOptions
        public typealias Element = GraphicsContext.ClipOptions
        public typealias RawValue = UInt32
    }

    public var clipBoundingRect: CGRect { .zero }

    public mutating func clip(to path: Path, style: FillStyle = FillStyle(), options: GraphicsContext.ClipOptions = ClipOptions()){

    }

    public mutating func clipToLayer(opacity: Double = 1, options: GraphicsContext.ClipOptions = ClipOptions(), content: (inout GraphicsContext) throws -> Void) rethrows{

    }


    public struct Filter {
        init(){}
        public static func projectionTransform(_ matrix: ProjectionTransform) -> GraphicsContext.Filter{
            return .init()
        }
        public static func shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0, blendMode: GraphicsContext.BlendMode = .normal, options: GraphicsContext.ShadowOptions = ShadowOptions()) -> GraphicsContext.Filter{
            return .init()
        }
        public static func colorMultiply(_ color: Color) -> GraphicsContext.Filter{
            return .init()
        }
        public static func colorMatrix(_ matrix: ColorMatrix) -> GraphicsContext.Filter{
            return .init()
        }

        public static func hueRotation(_ angle: Angle) -> GraphicsContext.Filter{
            return .init()
        }

        public static func saturation(_ amount: Double) -> GraphicsContext.Filter{
            return .init()
        }

        public static func brightness(_ amount: Double) -> GraphicsContext.Filter{
            return .init()
        }

        public static func contrast(_ amount: Double) -> GraphicsContext.Filter{
            return .init()
        }

        public static func colorInvert(_ amount: Double = 1) -> GraphicsContext.Filter{
            return .init()
        }

        public static func grayscale(_ amount: Double) -> GraphicsContext.Filter{
            return .init()
        }

        public static var luminanceToAlpha: GraphicsContext.Filter { return .init() }

        public static func blur(radius: CGFloat, options: GraphicsContext.BlurOptions = BlurOptions()) -> GraphicsContext.Filter{
            return .init()
        }

        public static func alphaThreshold(min: Double, max: Double = 1, color: Color = Color.black) -> GraphicsContext.Filter{
            return .init()
        }
    }

    @frozen public struct ShadowOptions : OptionSet {
        public let rawValue: UInt32
        @inlinable public init(rawValue: UInt32){
            self.rawValue = rawValue
        }

        @inlinable public static var shadowAbove: GraphicsContext.ShadowOptions { .init(rawValue: 1) }

        @inlinable public static var shadowOnly: GraphicsContext.ShadowOptions { .init(rawValue: 2) }

        @inlinable public static var invertsAlpha: GraphicsContext.ShadowOptions { .init(rawValue: 4)  }

        @inlinable public static var disablesGroup: GraphicsContext.ShadowOptions { .init(rawValue: 8) }

        public typealias ArrayLiteralElement = GraphicsContext.ShadowOptions

        public typealias Element = GraphicsContext.ShadowOptions

        public typealias RawValue = UInt32
    }

    @frozen public struct BlurOptions : OptionSet {
        public let rawValue: UInt32
        @inlinable public init(rawValue: UInt32){
            self.rawValue = rawValue
        }
        @inlinable public static var opaque: GraphicsContext.BlurOptions { .init(rawValue: 1)  }
        @inlinable public static var dithersResult: GraphicsContext.BlurOptions { .init(rawValue: 2)  }


        public typealias ArrayLiteralElement = GraphicsContext.BlurOptions
        public typealias Element = GraphicsContext.BlurOptions
        public typealias RawValue = UInt32
    }

    @frozen public struct FilterOptions : OptionSet {
        public let rawValue: UInt32
        @inlinable public init(rawValue: UInt32){
            self.rawValue = rawValue
        }

        @inlinable public static var linearColor: GraphicsContext.FilterOptions { .init(rawValue: 1)  }
        public typealias ArrayLiteralElement = GraphicsContext.FilterOptions
        public typealias Element = GraphicsContext.FilterOptions
        public typealias RawValue = UInt32
    }

    public mutating func addFilter(_ filter: GraphicsContext.Filter, options: GraphicsContext.FilterOptions = FilterOptions()){

    }
    
    public struct Shading {
        var storage: Storage
        init(_ storage: Storage = .unkown){
            self.storage = storage
        }

        enum Storage{
            case backdrop(Color._Resolved)
            case foreground
            case levels([Shading])
            case color(Color)
            case sRGBColor(RBColor)
            case style(AnyShapeStyle)
            case resolved(ResolvedShading)
            case unkown
        }
        public static var backdrop: GraphicsContext.Shading { 
            return .init(.backdrop(.init(linearRed: 0, green: 0, blue: 0, opacity: 0))) 
        }
        public static var foreground: GraphicsContext.Shading { .init(.foreground) }
        public static func palette(_ array: [GraphicsContext.Shading]) -> GraphicsContext.Shading{
            .init(.levels(array))
        }
        public static func color(_ color: Color) -> GraphicsContext.Shading{
            .init(.color(color))
        }
        public static func color(_ colorSpace: Color.RGBColorSpace = .sRGB, red: Double, green: Double, blue: Double, opacity: Double = 1) -> GraphicsContext.Shading{
            .init(.color(Color.init(colorSpace, red: red, green: green, blue: blue, opacity: opacity) ))
        }
        public static func color(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) -> GraphicsContext.Shading{
             .init(.color(Color.init(colorSpace, red: white, green: white, blue: white, opacity: opacity) ))
        }
        public static func style<S>(_ style: S) -> GraphicsContext.Shading where S : ShapeStyle{
            .init(.style(.init(style)))
        }

        public static func linearGradient(_ gradient: Gradient, startPoint: CGPoint, endPoint: CGPoint, options: GraphicsContext.GradientOptions = GradientOptions()) -> GraphicsContext.Shading{
            .init()
        }

        public static func radialGradient(_ gradient: Gradient, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, options: GraphicsContext.GradientOptions = GradientOptions()) -> GraphicsContext.Shading{
            .init()
        }
        public static func conicGradient(_ gradient: Gradient, center: CGPoint, angle: Angle = Angle(), options: GraphicsContext.GradientOptions = GradientOptions()) -> GraphicsContext.Shading{
            .init()
        }
        public static func tiledImage(_ image: Image, origin: CGPoint = .zero, sourceRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) -> GraphicsContext.Shading{
            .init()
        }
    }

    @frozen public struct GradientOptions : OptionSet {
        public let rawValue: UInt32
        @inlinable public init(rawValue: UInt32){
            self.rawValue = rawValue
        }
        @inlinable public static var `repeat`: GraphicsContext.GradientOptions { .init(rawValue: 1)  }
        @inlinable public static var mirror: GraphicsContext.GradientOptions { .init(rawValue: 2)  }
        @inlinable public static var linearColor: GraphicsContext.GradientOptions { .init(rawValue: 4)  }

        public typealias ArrayLiteralElement = GraphicsContext.GradientOptions
        public typealias Element = GraphicsContext.GradientOptions
        public typealias RawValue = UInt32
    }

    enum ResolvedShading{
        case color(Color._Resolved)
    }
    public func resolve(_ shading: GraphicsContext.Shading) -> GraphicsContext.Shading{
        return .init()
    }
    public func drawLayer(content: (inout GraphicsContext) throws -> Void) rethrows{

    }
    public func fill(_ path: Path, with shading: GraphicsContext.Shading, style: FillStyle = FillStyle()){

    }
    public func stroke(_ path: Path, with shading: GraphicsContext.Shading, style: StrokeStyle){

    }
    public func stroke(_ path: Path, with shading: GraphicsContext.Shading, lineWidth: CGFloat = 1){

    }
    public struct ResolvedImage {
        public var size: CGSize { .zero }
        public let baseline: CGFloat = 0
        public var shading: GraphicsContext.Shading? = nil
    }
    public func resolve(_ image: Image) -> GraphicsContext.ResolvedImage{
        return .init()
    }
    public func draw(_ image: GraphicsContext.ResolvedImage, in rect: CGRect, style: FillStyle = FillStyle()){

    }
    public func draw(_ image: GraphicsContext.ResolvedImage, at point: CGPoint, anchor: UnitPoint = .center){

    }
    public func draw(_ image: Image, in rect: CGRect, style: FillStyle = FillStyle()){

    }
    public func draw(_ image: Image, at point: CGPoint, anchor: UnitPoint = .center){

    }

    public struct ResolvedText {
        public var shading: GraphicsContext.Shading = .foreground
        public func measure(in size: CGSize) -> CGSize{
            return .zero
        }
        public func firstBaseline(in size: CGSize) -> CGFloat{
            return 0
        }
        public func lastBaseline(in size: CGSize) -> CGFloat{
            return 0
        }
    }
    public func resolve(_ text: Text) -> GraphicsContext.ResolvedText{
        return .init()
    }
    public func draw(_ text: GraphicsContext.ResolvedText, in rect: CGRect){

    }
    public func draw(_ text: GraphicsContext.ResolvedText, at point: CGPoint, anchor: UnitPoint = .center){

    }
    public func draw(_ text: Text, in rect: CGRect){

    }
    public func draw(_ text: Text, at point: CGPoint, anchor: UnitPoint = .center){

    }

    public struct ResolvedSymbol {
        public var size: CGSize { .zero }
    }
    public func resolveSymbol<ID>(id: ID) -> GraphicsContext.ResolvedSymbol? where ID : Hashable{
        return nil
    }
    public func draw(_ symbol: GraphicsContext.ResolvedSymbol, in rect: CGRect){

    }
    public func draw(_ symbol: GraphicsContext.ResolvedSymbol, at point: CGPoint, anchor: UnitPoint = .center){

    }
    public func withCGContext(content: (CGContext) throws -> Void) rethrows{
        try content(_context)
    }
}

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.BlendMode : Sendable {
// }

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.ClipOptions : Sendable {
// }

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.ShadowOptions : Sendable {
// }

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.BlurOptions : Sendable {
// }

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.FilterOptions : Sendable {
// }

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension GraphicsContext.GradientOptions : Sendable {
// }

@frozen public struct ColorMatrix : Equatable {

    public var r1: Float = 1

    public var r2: Float = 0

    public var r3: Float = 0

    public var r4: Float = 0

    public var r5: Float = 0

    public var g1: Float = 0

    public var g2: Float = 1

    public var g3: Float = 0

    public var g4: Float = 0

    public var g5: Float = 0

    public var b1: Float = 0

    public var b2: Float = 0

    public var b3: Float = 1

    public var b4: Float = 0

    public var b5: Float = 0

    public var a1: Float = 0

    public var a2: Float = 0

    public var a3: Float = 0

    public var a4: Float = 1

    public var a5: Float = 0

    @inlinable public init(){
    }
}

// @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
// extension ColorMatrix : Sendable {
// }

public struct ProjectionTransform{
}