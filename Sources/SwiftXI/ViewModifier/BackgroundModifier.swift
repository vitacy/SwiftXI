struct _BackgroundModifier<Background>: ViewModifier where Background: View {
    typealias Body = Never
    
    let background: Background
    let alignment: Alignment
    
    init(background: Background, alignment: Alignment) {
        self.background = background
        self.alignment = alignment
    }
}

extension View {
    public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background: View {
        return modifier(_BackgroundModifier(background: background, alignment: alignment))
    }
}
