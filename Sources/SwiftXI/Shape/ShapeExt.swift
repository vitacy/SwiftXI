import Foundation

extension Shape {
    @inlinable public func fill<S>(_ content: S, style: FillStyle = FillStyle()) -> some View where S: ShapeStyle {
        return _ShapeView.init(self, style: content, fillStyle: style)
    }
    @inlinable public func fill(style: FillStyle = FillStyle()) -> some View {
        return _ShapeView.init(self, style: ForegroundStyle.init(), fillStyle: style)
    }
    public func stroke<S>(_ content: S, style: StrokeStyle) -> some View where S: ShapeStyle {
        return _StrokedShape.init(self, style: style).fill(content)
    }
    public func stroke<S>(_ content: S, lineWidth: CGFloat = 1) -> some View where S: ShapeStyle {
        return self.stroke(content, style: StrokeStyle(lineWidth: lineWidth))
    }
    public func stroke(style: StrokeStyle) -> some Shape {
        return _StrokedShape.init(self, style: style)
    }
    public func stroke(lineWidth: CGFloat = 1) -> some Shape {
        return _StrokedShape.init(self, style: .init(lineWidth: lineWidth))
    }
}

extension Shape {
    @inlinable public func offset(_ offset: CGSize) -> OffsetShape<Self>{
        return .init(shape: self, offset: offset)
    }
    @inlinable public func offset(_ offset: CGPoint) -> OffsetShape<Self>{
        return self.offset(CGSize.init(width: offset.x, height: offset.y))
    }
    @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self>{
        return self.offset(CGSize.init(width: x, height: y))
    }
    @inlinable public func scale(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> ScaledShape<Self>{
        return .init(shape: self, scale: CGSize.init(width: x, height: y), anchor: anchor)
    }
    @inlinable public func scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> ScaledShape<Self>{
        return self.scale(x: scale, y: scale, anchor: anchor)
    }
    @inlinable public func rotation(_ angle: Angle, anchor: UnitPoint = .center) -> RotatedShape<Self>{
        return .init(shape: self, angle: angle, anchor: anchor)
    }
    @inlinable public func transform(_ transform: CGAffineTransform) -> TransformedShape<Self>{
        return .init(shape: self, transform: transform)
    }
}

extension Shape {
    public func trim(from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) -> some Shape {
        return _TrimmedShape.init(shape: self, startFraction: startFraction, endFraction: endFraction)
    }
}

extension Shape {
    public func size(_ size: CGSize) -> some Shape {
        return _SizedShape.init(shape: self, size: size)
    }
    @inlinable public func size(width: CGFloat, height: CGFloat) -> some Shape {
        return self.size(.init(width: width, height: height))
    }
}

struct _StrokedShape<T: Shape>: Shape {
    let shape: T
    let style: StrokeStyle
    init(_ shape: T, style: StrokeStyle = .init()) {
        self.shape = shape
        self.style = style
    }
    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).strokedPath(style)
    }
}
struct _SizedShape<T: Shape>: Shape {
    var shape: T
    var size: CGSize
    func path(in rect: CGRect) -> Path {
        return shape.path(in: .init(origin: rect.origin, size: size))
    }
    var animatableData: AnimatablePair<T.AnimatableData, CGSize.AnimatableData>{
        get { return .init(shape.animatableData, size.animatableData)}
        set {
            shape.animatableData = newValue.first
            size.animatableData = newValue.second
        }
    }
}

struct _TrimmedShape<T: Shape>: Shape {
    let shape: T
    let startFraction: CGFloat
    let endFraction: CGFloat
    func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).trimmedPath(from: startFraction, to: endFraction)
    }
}

public struct TransformedShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var transform: CGAffineTransform
    @inlinable public init(shape: Content, transform: CGAffineTransform){
        self.shape = shape
        self.transform = transform
    }
    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).applying(transform)
    }
    public var animatableData: Content.AnimatableData{
        get {shape.animatableData}
        set {shape.animatableData = newValue}
    }
}
public struct RotatedShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var angle: Angle
    public var anchor: UnitPoint
    @inlinable public init(shape: Content, angle: Angle, anchor: UnitPoint = .center){
        self.shape = shape
        self.angle = angle
        self.anchor = anchor
    }
    public func path(in rect: CGRect) -> Path{
        var point = CGPoint.init(x: anchor.x*rect.width, y: anchor.y*rect.height)
        point=point.offset(point: rect.origin)
        var trans = CGAffineTransform.init(translationX: point.x, y: point.y)
        trans=trans.rotated(by: angle.radians)
        trans=trans.translatedBy(x: -point.x, y: -point.y)
        return shape.path(in: rect).applying(trans)
    }
    public var animatableData: AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>{
        get { return .init(shape.animatableData, .init(angle.animatableData, anchor.animatableData))}
        set {
            shape.animatableData = newValue.first
            angle.animatableData = newValue.second.first
            anchor.animatableData = newValue.second.second
        }
    }
}

extension RotatedShape : InsettableShape where Content : InsettableShape {
    @inlinable public func inset(by amount: CGFloat) -> RotatedShape<Content.InsetShape>{
        return .init(shape: shape.inset(by: amount), angle: angle, anchor: anchor)
    }
}
public struct ScaledShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var scale: CGSize
    public var anchor: UnitPoint
    @inlinable public init(shape: Content, scale: CGSize, anchor: UnitPoint = .center){
        self.shape = shape
        self.scale = scale 
        self.anchor = anchor
    }
    public func path(in rect: CGRect) -> Path{
        let point = CGPoint.init(x: anchor.x*rect.width, y: anchor.y*rect.height).offset(point: rect.origin)
        var trans = CGAffineTransform.init(translationX: point.x, y: point.y)
        trans=trans.scaledBy(x: scale.width, y: scale.height)
        trans=trans.translatedBy(x: -point.x, y: -point.y)
        return shape.path(in: rect).applying(trans)
    }
    public var animatableData: AnimatablePair<Content.AnimatableData, AnimatablePair<CGSize.AnimatableData, UnitPoint.AnimatableData>>{
        get { return .init(shape.animatableData, .init(scale.animatableData, anchor.animatableData))}
        set {
            shape.animatableData = newValue.first
            scale.animatableData = newValue.second.first
            anchor.animatableData = newValue.second.second
        }
    }
}
public struct OffsetShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var offset: CGSize
    @inlinable public init(shape: Content, offset: CGSize){
        self.shape = shape
        self.offset = offset
    }
    public func path(in rect: CGRect) -> Path{
        return shape.path(in: rect).applying(.init(translationX: offset.width, y: offset.height))
    }

    public var animatableData: AnimatablePair<Content.AnimatableData, CGSize.AnimatableData>{
        get { return .init(shape.animatableData, offset.animatableData)}
        set {
            shape.animatableData = newValue.first
            offset.animatableData = newValue.second
        }
    }
}
extension OffsetShape : InsettableShape where Content : InsettableShape {
    @inlinable public func inset(by amount: CGFloat) -> OffsetShape<Content.InsetShape>{
        return .init(shape: shape.inset(by: amount), offset: offset)
    }
}