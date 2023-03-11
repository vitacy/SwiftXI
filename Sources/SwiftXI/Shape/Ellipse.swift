import Foundation
public struct Ellipse : Shape {
    public func path(in rect: CGRect) -> Path{
         return .init(ellipseIn: rect)
    }

    @inlinable public init(){}
}
