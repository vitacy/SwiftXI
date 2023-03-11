public struct AnyGesture<Value> : Gesture {
    public init<T>(_ gesture: T) where Value == T.Value, T : Gesture{

    }
}
extension AnyGesture: _NeverPublicBody{
}