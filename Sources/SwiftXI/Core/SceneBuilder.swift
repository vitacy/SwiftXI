@resultBuilder public struct SceneBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content : Scene{
        return content
    }
}
extension SceneBuilder {
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some Scene where C0 : Scene, C1 : Scene{
        return _TupleScene<(C0, C1)>.init((c0, c1))
    }
}

struct _TupleScene<T> : Scene {
    typealias Body = Never

    var value: T

    @inlinable public init(_ value: T){
        self.value = value
    }
}

extension _TupleScene: _NeverInternalBody{
}