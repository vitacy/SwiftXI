struct _TransactionModifier: ViewModifier {
    typealias Body = Never
    let transform: (inout Transaction) -> ()
}
struct _AnimationModifier<V: Equatable>: ViewModifier{
    typealias Body = Never
    let animation: Animation?
    let value: V
}
struct _PushPopTransactionModifier<T: ViewModifier>: ViewModifier{
    let content: T
    let base: _TransactionModifier
    func body(content view: Content) -> some View {
        view.modifier(content).modifier(base)
    }
}

extension View {
    public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some View{
        return modifier(_TransactionModifier.init(transform: transform))
    }
    public func animation(_ animation: Animation?) -> some View{
        return transaction{ t in
                if !t.disablesAnimations{
                    t.animation = animation
                }
            }
    }
    public func animation<V>(_ animation: Animation?, value: V) -> some View where V : Equatable{
        return modifier(_AnimationModifier.init(animation: animation, value: value))
    }
}

extension ViewModifier{
    public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier{
        return _PushPopTransactionModifier.init(content: self, base: .init(transform: transform))
    }
    public func animation(_ animation: Animation?) -> some ViewModifier{
        return _PushPopTransactionModifier.init(content: self, base: .init{t in
                if !t.disablesAnimations{
                    t.animation = animation
                }
            })
    }
}
