import Foundation

public struct Rectangle: Shape {
    public init(){
    }
    public func path(in rect: CGRect) -> Path {
        return .init(rect)
    }
}


