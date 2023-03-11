@frozen public enum Edge: Int8, CaseIterable {
    case top = 1
    case leading = 2
    case bottom = 4
    case trailing = 8
    
    public struct Set: OptionSet {
        public typealias Element = Edge.Set
        public typealias ArrayLiteralElement = Edge.Set.Element

        public let rawValue: Edge.RawValue
        
        public static let top: Edge.Set = .init(.top)
        public static let leading: Edge.Set = .init(.leading)
        public static let bottom: Edge.Set = .init(.bottom)
        public static let trailing: Edge.Set = .init(.trailing)
        public static let horizontal: Edge.Set=[.trailing, .leading]
        public static let vertical: Edge.Set = [.top, .bottom]
        
        public static let all: Edge.Set = [.top, .bottom, .trailing, .leading]
        
        public init(rawValue: Edge.RawValue) {
            self.rawValue = rawValue
        }
        public init(_ e: Edge) {
            self.rawValue = e.rawValue
        }
    }
}

extension Edge: Hashable {
}

extension Edge: RawRepresentable {
}
