extension View {
    public func brightness(_ amount: Double) -> some View{
        return modifier(_BrightnessEffect.init(amount: amount))
    }
    public func colorInvert() -> some View{
        return modifier(_ColorInvertEffect.init())
    }
    public func colorMultiply(_ color: Color) -> some View{
        return modifier(_ColorMultiplyEffect.init(color: color))
    }
    public func contrast(_ amount: Double) -> some View{
        return modifier(_ContrastEffect.init(amount: amount))
    }
    public func grayscale(_ amount: Double) -> some View{
        return modifier(_GrayscaleEffect.init(amount: amount))
    }
    public func hueRotation(_ angle: Angle) -> some View{
        return modifier(_HueRotationEffect.init(angle: angle))
    }
    public func luminanceToAlpha() -> some View{
        return modifier(_LuminanceToAlphaEffect())
    }
    public func saturation(_ amount: Double) -> some View{
        return modifier(_SaturationEffect.init(amount: amount))
    }
    public func opacity(_ opacity: Double) -> some View{
        return modifier(_OpacityEffect.init(opacity: opacity))
    }
    public func blendMode(_ blendMode: BlendMode) -> some View{
        return modifier(_BlendModeEffect.init(blendMode: blendMode))
    }
    public func shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View{
        return modifier(_ShadowEffect.init(color: color, radius: radius, offset: .init(width: x, height: y)))
    }
}
struct _BrightnessEffect: ViewModifier{
    typealias Body = Never
    var amount: Double
}
struct _ColorMultiplyEffect: ViewModifier{
    typealias Body = Never
    var color: Color
}
struct _ColorInvertEffect: ViewModifier{
    typealias Body = Never
}
struct _ContrastEffect: ViewModifier{
    typealias Body = Never
    var amount: Double
}
struct _GrayscaleEffect: ViewModifier{
    typealias Body = Never
    var amount: Double
}
struct _HueRotationEffect: ViewModifier{
    typealias Body = Never
    var angle: Angle
}
struct _SaturationEffect: ViewModifier{
    typealias Body = Never
    var amount: Double
}
struct _LuminanceToAlphaEffect: ViewModifier{
    typealias Body = Never
}
struct _OpacityEffect: AnimatableModifier{
    typealias Body = Never
    var opacity: Double
    var animatableData: Double{
        get { return opacity }
        set {
            opacity = newValue
        }
    }
}

struct _ShadowEffect: ViewModifier{
    typealias Body = Never
    var color: Color
    var radius: CGFloat
    var offset: CGSize
}
struct _BlendModeEffect: ViewModifier{
    typealias Body = Never
    var blendMode: BlendMode
}
public typealias BlendMode = CGBlendMode
