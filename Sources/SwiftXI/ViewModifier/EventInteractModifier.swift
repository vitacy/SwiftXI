extension View {
    public func contentShape<S>(_ shape: S, eoFill: Bool = false) -> some View where S : Shape{
        return modifier(_ContentShapeModifier.init(shape: shape, eoFill: eoFill))
    }
    public func onHover(perform action: @escaping (Bool) -> Void) -> some View{
        return modifier(_HoverRegionModifier.init(callback: action))
    }

    func onScrollWheel(perform action: @escaping (CGSize) -> Void) -> some View{
        return modifier(_ScrollWheelEventModifier.init(callback: action))
    }
    
    public func disabled(_ disabled: Bool) -> some View{
        return transformEnvironment(\EnvironmentValues.isEnabled){ isEnabled in
            isEnabled = isEnabled && !disabled
        }
    }

    public func hidden() -> some View{
        return modifier(_HiddenModifier.init())
    }
    public func allowsHitTesting(_ enabled: Bool) -> some View{
        return modifier(_AllowsHitTestingModifier.init(allowsHitTesting: enabled))
    }
}


struct _ContentShapeModifier<S> : ViewModifier where S : Shape{
    typealias Body = Never
    let shape: S
    let eoFill: Bool
}

struct _HoverRegionModifier : ViewModifier {
    typealias Body = Never
    let callback: (Bool) -> Void
}
struct _ScrollWheelEventModifier : ViewModifier {
    typealias Body = Never
    let callback: (CGSize) -> Void
}

struct _HiddenModifier: ViewModifier{
    typealias Body = Never
}
struct _AllowsHitTestingModifier : ViewModifier{
    typealias Body = Never
    let allowsHitTesting: Bool
}
private struct _IsEnabledKey: EnvironmentKey {
    static var defaultValue: Bool {
        return true
    }
}
extension EnvironmentValues {
    public var isEnabled: Bool{
        get { return self[_IsEnabledKey.self] }
        set { self[_IsEnabledKey.self] = newValue }
    }
}