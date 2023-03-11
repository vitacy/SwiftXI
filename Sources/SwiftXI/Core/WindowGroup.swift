public struct WindowGroup<Content> : Scene where Content : View {
    var _content: Content
    public init(@ViewBuilder content: () -> Content){
        _content = content()
    }

    public typealias Body = Never
}

extension WindowGroup : _NeverPublicBody{
}