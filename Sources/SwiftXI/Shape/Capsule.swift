public struct Capsule : Shape {
    public var style: RoundedCornerStyle

    public init(style: RoundedCornerStyle = .circular){
        self.style = style
    }
    public func path(in rect: CGRect) -> Path{
        let radius = min(rect.size.width, rect.size.height)/2
        return .init(roundedRect: rect, cornerRadius: radius, style: style)
    }
}
extension Capsule : _InsetShape {
}
extension Capsule : InsettableShape {
}