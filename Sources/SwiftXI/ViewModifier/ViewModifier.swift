public protocol ViewModifier {
    associatedtype Body: View
    @ViewBuilder func body(content: Self.Content) -> Self.Body
    typealias Content = _ViewModifier_Content<Self>
}
public protocol AnimatableModifier : Animatable, ViewModifier {
}

extension ViewModifier where Self.Body == Never {
    public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}
extension ViewModifier {
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}
public struct _ViewModifier_Content<Modifier> where Modifier: ViewModifier {
    public typealias Body = Never
    var content: AnyView? = nil
}

extension _ViewModifier_Content: View {
}

extension _ViewModifier_Content: _NeverPublicBody{
}