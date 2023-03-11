struct _AspectRatioLayout: ViewModifier{
    var aspectRatio: CGFloat?
    var contentMode: ContentMode

    typealias Body = Never
}
public enum ContentMode : Hashable, CaseIterable {
    case fit
    case fill
}
extension View {
    public func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: ContentMode) -> some View{
        return modifier(_AspectRatioLayout.init(aspectRatio: aspectRatio, contentMode: contentMode))
    }
    public func aspectRatio(_ aspectRatio: CGSize, contentMode: ContentMode) -> some View{
        return self.aspectRatio(aspectRatio.width/aspectRatio.height, contentMode: contentMode)
    }
    public func scaledToFit() -> some View{
        return aspectRatio(contentMode: .fit)
    }
    public func scaledToFill() -> some View{
        return aspectRatio(contentMode: .fill)
    }
}