extension View {
    public func transformEffect(_ transform: CGAffineTransform) -> some View{
        return modifier(_TransformEffect.init(transform: transform))
    }
    public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some View{
        return modifier(_RotationEffect.init(angle: angle, anchor: anchor))
    }
    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some View{
        return modifier(_ScaleEffect.init(scale: scale, anchor: anchor))
    }
    public func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View{
        return scaleEffect(CGSize.init(width: s, height: s), anchor: anchor)
    }
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> some View{
        return scaleEffect(CGSize.init(width: x, height: y), anchor: anchor)
    }
}

struct _TransformEffect: ViewModifier{
    typealias Body = Never
    let transform: CGAffineTransform
}
struct _ScaleEffect: ViewModifier{
    typealias Body = Never
    var scale: CGSize
    var anchor: UnitPoint
}

extension _ScaleEffect: AnimatableModifier {
    var animatableData: AnimatablePair<CGSize.AnimatableData, UnitPoint.AnimatableData>{
        get { return .init(scale.animatableData, anchor.animatableData)}
        set {
            scale.animatableData = newValue.first
            anchor.animatableData = newValue.second
        }
    }
}

struct _RotationEffect: ViewModifier{
    typealias Body = Never
    var angle: Angle
    var anchor: UnitPoint
}

extension _RotationEffect: AnimatableModifier {
    var animatableData: AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>{
        get { return .init(angle.animatableData, anchor.animatableData)}
        set {
            angle.animatableData = newValue.first
            anchor.animatableData = newValue.second
        }
    }
}