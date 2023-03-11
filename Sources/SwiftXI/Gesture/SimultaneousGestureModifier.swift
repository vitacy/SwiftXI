struct SimultaneousGestureModifier<T: Gesture>: ViewModifier {
    var gesture: T
    var gestureMask: GestureMask
    typealias Body = Never
}

extension View {
    public func simultaneousGesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture {
        return modifier(SimultaneousGestureModifier.init(gesture: gesture, gestureMask: mask))
    }
}


extension SimultaneousGestureModifier: _DefaultGestureEventProcess{
    func gestureContextInit(value: inout _GestureContextValue){
        value.simultaneousGesture = true
    }
}