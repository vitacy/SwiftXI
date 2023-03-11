struct AddGestureModifier<T: Gesture>: ViewModifier {
    var gesture: T
    var gestureMask: GestureMask
    typealias Body = Never
}

extension View {
    public func gesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T: Gesture {
        return modifier(AddGestureModifier.init(gesture: gesture, gestureMask: mask))
    }
}

extension AddGestureModifier: _DefaultGestureEventProcess {
    func gestureContextInit(value: inout _GestureContextValue){
    }
}