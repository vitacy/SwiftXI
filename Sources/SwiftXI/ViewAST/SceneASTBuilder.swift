protocol SceneASTBuilder {
    func makeScenes() -> [SceneASTNode]
}
class SceneASTNode {
    var value: Any
    weak var window: SwiftUIWindow? = nil

    init<T>(_ t: T) where T: Scene {
        value = t as Any
    }
    init?(any t: Any) {
        let s = t as? SceneASTBuilder
        guard s != nil else {
            return nil
        }
        value = t
    }
}
extension WindowGroup: SceneASTBuilder {
    func makeScenes() -> [SceneASTNode] {
        var arr = [SceneASTNode]()
        arr.append(SceneASTNode(self))
        return arr
    }
}
extension _TupleScene: SceneASTBuilder {
    func makeScenes() -> [SceneASTNode] {
        var arr = [SceneASTNode]()
        let valueMirror = Mirror(reflecting: value)
        for case let (_, scene) in valueMirror.children {
            arr.append(SceneASTNode(any: scene)!)
        }
        return arr
    }
}
