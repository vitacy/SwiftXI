extension Optional {
    public typealias Body = Never
}
extension Optional: View where Wrapped: View {
    
}
extension Optional: Gesture where Wrapped: Gesture {
    public typealias Value = Wrapped.Value
}

extension Optional : _NeverPublicBody{
}

