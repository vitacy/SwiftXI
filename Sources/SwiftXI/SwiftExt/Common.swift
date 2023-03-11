extension UnsafeMutablePointer {
    func asPointer<T>() -> UnsafeMutablePointer<T> {
        let op: OpaquePointer = OpaquePointer.init(self)
        return .init(op)
    }
}
extension OpaquePointer {
    func asPointer<T>() -> UnsafeMutablePointer<T> {
        return .init(self)
    }
}

extension FixedWidthInteger{
    func asInteger<T: FixedWidthInteger>() -> T{
        return T(self)
    }
}

extension String{
    static func from(cString: UnsafePointer<CChar>?) -> String{
        if let cString = cString{
            return String.init(cString: cString)
        }
        return ""
    }
}