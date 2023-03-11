import Foundation

public protocol Shape: Animatable, View {
    func path(in rect: CGRect) -> Path
}

extension Shape {
    public var body: some View {
        return _ShapeView.init(self, style: ForegroundStyle.init())
    }
}


public struct _ShapeView<T: Shape, S: ShapeStyle>: View {
    let shape: T
    let style: S
    let fillStyle: FillStyle
    public init(_ shape: T, style: S, fillStyle fill: FillStyle = .init()) {
        self.shape = shape
        self.style = style
        self.fillStyle = fill
    }
    public typealias Body = Never
}
extension _ShapeView: _NeverPublicBody{
}


