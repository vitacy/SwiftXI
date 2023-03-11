public enum CoordinateSpace {
    case global
    case local
    case named(AnyHashable)
}

extension CoordinateSpace {
    public var isGlobal: Bool { return self == .global }
    public var isLocal: Bool { return self == .local }
}


extension CoordinateSpace : Equatable, Hashable {
}