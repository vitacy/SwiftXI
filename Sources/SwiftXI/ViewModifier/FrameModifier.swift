import Foundation

extension View {
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return modifier(_FrameLayout(width: width, height: height, alignment: alignment))
    }
    public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View{
        return modifier(_FlexFrameLayout(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment))
    }
    public func offset(_ offset: CGSize) -> some View{
        return modifier(_OffsetEffect(offset: offset))
    }
    public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View{
        return offset(CGSize.init(width: x, height: y))
    }

    public func position(_ position: CGPoint) -> some View{
        return modifier(_PositionLayout(position: position))
    }

    public func position(x: CGFloat = 0, y: CGFloat = 0) -> some View{
        return position(CGPoint.init(x: x, y: y))
    }

    public func fixedSize(horizontal: Bool, vertical: Bool) -> some View{
        return modifier(_FixedSizeLayout(horizontal: horizontal, vertical: vertical))
    }
    public func fixedSize() -> some View{
        return fixedSize(horizontal: true, vertical: true)
    }
}

struct _FrameLayout : ViewModifier{
    typealias Body = Never

    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment
}

struct _FlexFrameLayout : ViewModifier{
    typealias Body = Never

    var minWidth: CGFloat? 
    var idealWidth: CGFloat? 
    var maxWidth: CGFloat? 
    var minHeight: CGFloat? 
    var idealHeight: CGFloat? 
    var maxHeight: CGFloat? 
    var alignment: Alignment 
}

struct _OffsetEffect : AnimatableModifier{
    typealias Body = Never
    var offset: CGSize
    var animatableData: CGSize.AnimatableData{
        get { return offset.animatableData}
        set {
            offset.animatableData = newValue
        }
    }
}

struct _PositionLayout: ViewModifier{
    typealias Body = Never
    var position: CGPoint
}

struct _FixedSizeLayout: ViewModifier{
    typealias Body = Never
    let horizontal: Bool
    let vertical: Bool
}