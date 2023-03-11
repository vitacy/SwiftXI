public protocol EnvironmentalModifier : ViewModifier where Self.Body == Never {
    associatedtype ResolvedModifier : ViewModifier
    func resolve(in environment: EnvironmentValues) -> Self.ResolvedModifier
}

struct _EnvironmentKeyWritingModifier<Value>: ViewModifier {
    var keyPath: WritableKeyPath<EnvironmentValues, Value>
    var value: Value
    typealias Body = Never
}

extension View {
    public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View {
        return modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
    }
    public func transformEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, transform: @escaping (inout V) -> Void) -> some View{
        return modifier(_EnvironmentKeyTransformModifier.init(keyPath: keyPath, transform: transform))
    }
}

struct _EnvironmentKeyTransformModifier<Value> : ViewModifier{
    typealias Body = Never
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    let transform: (inout Value) -> ()
}