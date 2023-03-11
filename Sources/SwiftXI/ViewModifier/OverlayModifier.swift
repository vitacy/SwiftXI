struct _OverlayModifier<Content: View> : ViewModifier{
    typealias Body = Never
    let overlay: Content
    let alignment: Alignment
}


extension View {
    public func overlay<Overlay>(_ overlay: Overlay, alignment: Alignment = .center) -> some View where Overlay : View{
        return modifier(_OverlayModifier(overlay: overlay, alignment: alignment))
    }

    public func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle{
        return self.overlay(Rectangle().stroke(content, lineWidth: width))
    }
}