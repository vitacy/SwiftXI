class AnyViewStorageBase: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode){
    }
}

class AnyViewStorage<V: View>: AnyViewStorageBase {
    var view: V
    init(_ view: V) {
        self.view = view
    }
    override func _buildViews(node: AnyASTNode){
        node.buildContentViewDefault(view)
    }
}

public struct AnyView: View {
    var storage: AnyViewStorageBase
    public init<T: View>(_ view: T) {
        storage = AnyViewStorage(view)
    }
}
extension AnyView : _NeverPublicBody{
}
