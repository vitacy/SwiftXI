import Foundation

extension Circle: _InsetShape{
}
extension Ellipse : _InsetShape {
}
extension Rectangle: _InsetShape{
}
extension RoundedRectangle : _InsetShape {
}

public protocol InsettableShape: Shape {
    associatedtype InsetShape: InsettableShape
    func inset(by amount: CGFloat) -> Self.InsetShape
}

extension InsettableShape {
    @inlinable public func strokeBorder<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> some View where S : ShapeStyle{
        return self.inset(by: style.lineWidth*0.5).stroke(style: style).fill(content, style: FillStyle.init(antialiased: antialiased))
    }
    @inlinable public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> some View{
        return self.strokeBorder(ForegroundStyle.init(), style: style, antialiased: antialiased)
    }
    @inlinable public func strokeBorder<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View where S : ShapeStyle{
        return self.strokeBorder(content, style: StrokeStyle.init(lineWidth: lineWidth), antialiased: antialiased)
    }
    @inlinable public func strokeBorder(lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View{
        return self.strokeBorder(ForegroundStyle.init(), lineWidth: lineWidth, antialiased: antialiased)
    }
}

public protocol _InsetShape: InsettableShape{
}
extension InsettableShape where Self: _InsetShape{
    public func inset(by amount: CGFloat) -> some InsettableShape{
        return _Inset.init(amount, shape: self)
    }
}
struct _Inset<T: _InsetShape>: _InsetShape{
    let amount: CGFloat
    let shape: T
    init(_ amount: CGFloat, shape: T){
        self.amount = amount
        self.shape = shape
    }
    public func inset(by amount: CGFloat) -> some InsettableShape{
        return _Inset.init(self.amount + amount, shape: self.shape)
    }
    public func path(in rect: CGRect) -> Path{
        let r = rect.insetBy(dx: amount, dy: amount)
        return shape.path(in: r)
    }
}