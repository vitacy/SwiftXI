extension View {
        public func clipShape<S>(_ shape: S, style: FillStyle = FillStyle()) -> some View where S : Shape{
                return modifier(_ClipEffect.init(shape: shape, style: style))
        }
        public func clipped(antialiased: Bool = false) -> some View{
                return modifier(_ClipEffect.init(shape: Rectangle(), style: FillStyle.init(eoFill: false, antialiased: antialiased)))
        }
        public func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> some View{
                return modifier(_ClipEffect.init(shape: RoundedRectangle.init(cornerRadius: radius), style: FillStyle.init(eoFill: false, antialiased: antialiased)))
        }
        public func drawingGroup(opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear) -> some View{
                return modifier(_DrawingGroupEffect.init(opaque: opaque, colorMode: colorMode))
        }
        public func compositingGroup() -> some View{
                return modifier(_CompositingGroupEffect())
        }
}

struct _ClipEffect<S> : ViewModifier where S : Shape{
    typealias Body = Never
    var shape: S
    let style: FillStyle
    var animatableData: S.AnimatableData{
        get {shape.animatableData}
        set {shape.animatableData = newValue}
    }
}

extension _ClipEffect: AnimatableModifier{
}

struct _CompositingGroupEffect: ViewModifier{
    typealias Body = Never
}

public enum ColorRenderingMode: Hashable {
    case nonLinear
    case linear
    case extendedLinear
}
struct _DrawingGroupEffect: ViewModifier{
    typealias Body = Never
    var opaque: Bool
    var colorMode: ColorRenderingMode
}