

struct ModifierGesture<M, T: Gesture>: Gesture {
    typealias Value = T.Value
    var content: T
    var modifier: M
}
extension ModifierGesture: _NeverPublicBody{
}
struct CallbacksGesture<T> {
    var callbacks: T
}
