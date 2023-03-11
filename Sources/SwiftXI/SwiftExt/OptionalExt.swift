extension Optional {
    func asString() -> String {
        return String(describing: self)
    }
}

extension Optional where Wrapped == Any{
    @inlinable func asType<T>() -> T?{
        if self == nil{
            return nil
        } 
        return self! as? T
    }
}