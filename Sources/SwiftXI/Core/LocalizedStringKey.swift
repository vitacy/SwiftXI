
public struct LocalizedStringKey : Equatable, ExpressibleByStringInterpolation {
    let key: String
    public init(_ value: String){
        key = value
    }
    public init(stringLiteral value: String){
        key = value
    }
}