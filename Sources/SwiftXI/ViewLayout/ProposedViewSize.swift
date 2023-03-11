public struct ProposedViewSize : Equatable {
    public var width: CGFloat?
    public var height: CGFloat?
    public static let zero: ProposedViewSize = .init(width: 0, height: 0)
    public static let unspecified: ProposedViewSize = .init(width: nil, height: nil)
    public static let infinity: ProposedViewSize = .init(width: .infinity, height: .infinity)
    @inlinable public init(width: CGFloat?, height: CGFloat?){
        self.width = width
        self.height = height
    }
    @inlinable public init(_ size: CGSize){
        self.init(width: size.width, height: size.height)
    }
    @inlinable public func replacingUnspecifiedDimensions(by size: CGSize = CGSize(width: 10, height: 10)) -> CGSize{
        return .init(width: width ?? size.width, height: height ?? size.height)
    }
}

extension ProposedViewSize : Sendable {
}