public protocol ShapeStyle {
}
extension ShapeStyle {
    public func `in`(_ rect: CGRect) -> some ShapeStyle{
        return _AnchoredShapeStyle.init(style: self, bounds: rect)
    }
}
extension ShapeStyle where Self: View, Self.Body == _ShapeView<Rectangle, Self> {
    public var body: _ShapeView<Rectangle, Self> {
        return .init(Rectangle(), style: self)
    }
}

public struct ForegroundStyle {
    @inlinable public init() {
    }
}
extension ForegroundStyle: ShapeStyle {
}
 public struct BackgroundStyle {
    @inlinable public init(){
    }
}
extension BackgroundStyle : ShapeStyle {
}

extension StrokeStyle: Animatable {
    public var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>{
        get {.init(lineWidth, .init(miterLimit, dashPhase))}
        set {
            lineWidth = newValue.first
            miterLimit = newValue.second.first
            dashPhase = newValue.second.second
        }
    }
}

struct _AnchoredShapeStyle<Content: ShapeStyle>: ShapeStyle{
    let style: Content
    let bounds: CGRect
}

public struct AnyShapeStyle : ShapeStyle {
    public init<S>(_ style: S) where S : ShapeStyle{
    }
}