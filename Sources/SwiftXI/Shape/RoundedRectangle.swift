import Foundation


public struct RoundedRectangle : Shape {
    public var cornerSize: CGSize
    public var style: RoundedCornerStyle

    @inlinable public init(cornerSize: CGSize, style: RoundedCornerStyle = .circular){
        self.cornerSize = cornerSize
        self.style = style
    }

    @inlinable public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular){
        self.cornerSize = .init(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    public func path(in rect: CGRect) -> Path{
        return .init(roundedRect: rect, cornerSize: cornerSize, style: style)
    }

    public var animatableData: CGSize.AnimatableData{
        get {cornerSize.animatableData}
        set { cornerSize.animatableData = newValue}
    }
}

