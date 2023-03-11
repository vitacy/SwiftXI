import Foundation

public struct Circle : Shape {
    public func path(in rect: CGRect) -> Path{
        let radius = min(rect.width, rect.height)
        let circleRect = CGRect.init(center: rect.centerPoint, size: .init(width: radius, height: radius))
        return .init(ellipseIn: circleRect)
    }
    @inlinable public init(){
    }
}



