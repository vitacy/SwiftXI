public struct ModifiedContent<Content, Modifier> {
    public var content: Content
    public var modifier: Modifier
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}
extension ModifiedContent : Equatable where Content : Equatable, Modifier : Equatable {
}

extension ModifiedContent: View where Content: View, Modifier: ViewModifier {
}
extension ModifiedContent: _NeverPublicBody{
}

extension View {
    public func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}




