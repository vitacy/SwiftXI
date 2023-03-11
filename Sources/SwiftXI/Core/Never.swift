extension Never {
    public typealias Body = Never
}

extension Never: View {
}
extension Never: Scene {
}
extension Never : Gesture {
    public typealias Value = Never
}


protocol _NeverPublicBody {
}

extension _NeverPublicBody {
    public var body: Never {
        fatalError()
    }
}
extension Never: _NeverPublicBody{
}

protocol _NeverInternalBody {
}

extension _NeverInternalBody{
    var body: Never {
        fatalError()
    }
}