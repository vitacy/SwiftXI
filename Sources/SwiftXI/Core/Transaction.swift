public struct Transaction {
    var plist = PropertyList.init()

    public init() {
    }

    struct Key<T: _TransactionKey>: PropertyListKey{
        typealias Value = T.Value
    }
    subscript<K>(key: K.Type) -> K.Value where K: _TransactionKey {
        get { return plist[Key<K>.self] ?? K.defaultValue }
        set { plist[Key<K>.self] = newValue }
    }
}


protocol _TransactionKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

extension Transaction{
    struct _DisablesAnimationsKey : _TransactionKey{
        static var defaultValue: Bool {
            return false
        }
    }
    struct _AnimationKey : _TransactionKey{
        static var defaultValue: Animation? {
            return nil
        }
    }
    public var disablesAnimations: Bool{
        get {return self[_DisablesAnimationsKey.self]}
        set {self[_DisablesAnimationsKey.self] = newValue}
    }
    public var animation: Animation?{
        get {return self[_AnimationKey.self]}
        set {self[_AnimationKey.self] = newValue}
    }
}
extension Transaction {
    public init(animation: Animation?){
        self.animation = animation
    }
    static var transactions: [Transaction] = .init()
    static var current: Transaction = .init()
}

public func withAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result{
    var t = Transaction.current
    t.animation = animation
    return try withTransaction(t, body)
}
public func withTransaction<Result>(_ transaction: Transaction, _ body: () throws -> Result) rethrows -> Result{
    let old = Transaction.current
    if (old.animation == transaction.animation 
        && old.disablesAnimations == transaction.disablesAnimations){
        return try body()
    }
    defer{
        Transaction.transactions.append(Transaction.current)
        Transaction.current = old
    }
    Transaction.transactions.append(Transaction.current)
    Transaction.current = transaction
    return try body()
}
extension Transaction{
    static func transform<Result>(_ transform: (inout Transaction) -> (), _ body: () throws -> Result) rethrows -> Result{
        let old = Transaction.current
        defer{
            Transaction.current = old
        }
        transform(&Transaction.current)
        return try body()
    }
}


