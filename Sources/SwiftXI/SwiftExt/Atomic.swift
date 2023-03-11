@propertyWrapper
struct atomic<T> {
    private var value: T
    private let lock = NSLock()

    init(wrappedValue value: T) {
        self.value = value
    }

    var wrappedValue: T {
        get { getValue() }
        set { setValue(newValue: newValue) }
    }

    func getValue() -> T {
        lock.lock()
        defer { lock.unlock() }

        return value
    }

    mutating func setValue(newValue: T) {
        lock.lock()
        defer { lock.unlock() }

        value = newValue
    }
}

private struct _PrivateAtomicLock {
    fileprivate static let lock = NSLock()
}
@propertyWrapper
struct atomic_global<T> {
    private var value: T
    private var lock: NSLock{
        return _PrivateAtomicLock.lock
    }

    init(wrappedValue value: T) {
        self.value = value
    }

    var wrappedValue: T {
        get { getValue() }
        set { setValue(newValue: newValue) }
    }

    func getValue() -> T {
        lock.lock()
        defer { lock.unlock() }

        return value
    }

    mutating func setValue(newValue: T) {
        lock.lock()
        defer { lock.unlock() }

        value = newValue
    }
}


extension NSLock {
    func synchronized<T>(closure: () -> T) -> T {
        self.lock()
        defer {
            self.unlock()
        }
        return closure()
    }

    func synchronized(closure: (inout (() -> Void)?) -> Void) {
        var outter: (() -> Void)? = nil
        self.synchronized {
            closure(&outter)
        }
        outter?()
    }
}
