
public protocol ButtonStyle {
    associatedtype Body : View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = ButtonStyleConfiguration
}

public struct ButtonStyleConfiguration {
    public struct Label : View {
        let content: AnyView
    }

    public let label: ButtonStyleConfiguration.Label
    public let isPressed: Bool
}

extension ButtonStyleConfiguration.Label : _NeverPublicBody{
}

struct WrappedButtonStyle<Style>: PrimitiveButtonStyle where Style: ButtonStyle{
    let style: Style
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> some View{
        _ButtonPressReader{ pressed in
            let config = ButtonStyleConfiguration.init(label: .init(content: configuration.label.content), isPressed: pressed)
            style.makeBody(configuration: config)
        }.onTapGesture(perform: configuration.trigger)
    }
}

extension View {
    public func buttonStyle<S>(_ style: S) -> some View where S : PrimitiveButtonStyle{
        return modifier(ButtonStyleModifier.init(style: style))
    }
    public func buttonStyle<S>(_ style: S) -> some View where S : ButtonStyle{
        return buttonStyle(WrappedButtonStyle.init(style: style))
    }
}
struct ButtonStyleModifier<Style>: ViewModifier where Style: PrimitiveButtonStyle {
    typealias Body = Never
    let style: Style
}

struct _ButtonStyleKey: EnvironmentKey {
    static var defaultValue: [any PrimitiveButtonStyle] {
        return []
    }
}
extension EnvironmentValues {
    var _buttonStyles: [any PrimitiveButtonStyle] {
        get { return self[_ButtonStyleKey.self] }
        set { self[_ButtonStyleKey.self] = newValue }
    }
}