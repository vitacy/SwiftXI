@frozen public enum Axis: Int8, CaseIterable {
    case horizontal = 1
    case vertical = 2
    @frozen public struct Set : OptionSet {
        public typealias Element = Axis.Set
        public typealias RawValue = Axis.RawValue
        public typealias ArrayLiteralElement = Axis.Set.Element

        public let rawValue: RawValue
        public init(rawValue: RawValue){
            self.rawValue = rawValue
        }
        public static let horizontal: Axis.Set = .init(rawValue: Axis.horizontal.rawValue)
        public static let vertical: Axis.Set =  .init(rawValue: Axis.vertical.rawValue)
    }
}

extension Axis : CustomStringConvertible {
    public var description: String {
        switch self{
            case .horizontal:
            return "horizontal"
            case .vertical:
            return "vertical"
        }
     }
}

extension Axis : Equatable {
}

extension Axis : Hashable {
}

extension Axis : RawRepresentable {
}