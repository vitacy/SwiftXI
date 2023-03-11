protocol AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode)
}

protocol _ViewModifierBuilder {
    func _configViews(node: AnyASTNode)
    func _buildViews(node: AnyASTNode)
    func _buildViews<T: View>(node: AnyASTNode, content: T)
}
extension _ViewModifierBuilder{
    func _buildViews(node: AnyASTNode){
    }
    func _configViews(node: AnyASTNode){
    }
    func _buildViews<T: View>(node: AnyASTNode, content: T){
        _configViews(node: node)
        _buildViews(node: node)
        node.buildContentViewDefault(content)
    }
}
protocol _CustomAnyASTNodeBuilder{
    func _makeAstNode() -> AnyASTNode
}
extension AnyASTNode {
    func configDataWith(parent: AnyASTNode) {
        self.environments = parent.environments
        self.scene = parent.scene
        self.parent = parent
        self.depth = parent.depth + 1
    }
    func configChildNode<T: View>(view: T, node: AnyASTNode) {
        node.value = view
        node.configDataWith(parent: self)
        node.makeViewState(view: view)
    }

    func childBy(id: AnyHashable) -> AnyASTNode?{
        return children.first{$0.id == id}
    }
    func buildContentViewDefault<V: View>(_ view: V, id: AnyHashable? = nil) {
        var node = children.first
        if node == nil || node!.id != id || node!._type != V.self{
            children.removeAll()
            node = createNewChildNode(view, id: id)
        }

        guard let node = node else{
            return
        }
        configChildNode(view: view, node: node)
        node._buildBodyViewDefault(view: view)
    }

    func buildContentView<V: View>(_ view: V, offset: Int){
        guard children.count + 1 >= offset else {
            print("create view error \(children.count) but need \(offset)")
            return
        }

        if (children.count <= offset) {
            let _ = createNewChildNode(view, id: id)
        }

        let node = children[offset]

        configChildNode(view: view, node: node)
        node._buildBodyViewDefault(view: view)
    }
    func buildContentView<V: View>(_ view: V, id: AnyHashable){
        let node = childBy(id: id) ?? createNewChildNode(view, id: id)

        configChildNode(view: view, node: node)
        node._buildBodyViewDefault(view: view)
    }
    func createNewChildNode<V: View> (_ view: V, id: AnyHashable?) -> AnyASTNode{
        print("create once \(V.self) for \(self.name)")
        let node: AnyASTNode = (view as? _CustomAnyASTNodeBuilder)?._makeAstNode() ?? ViewASTNode.init(view)
        node.id = id
        children.append(node)
        return node
    }
    func makeViewState<V: View>(view: V) {
        for (label, value) in Mirror(reflecting: view).children {
            if var state = value as? _MakeDynamicProperty {
                state._makeProperty(node: self, forKey: label!)
            }
        }
    }

    func _buildBodyViewDefault<V: View>(view: V) {
        if let render = view as? AnyASTNodeBuilder {
            render._buildViews(node: self)
        } else {
            if false == V.self.Body is Never.Type {
                buildContentViewDefault(view.body)
            }
        }
        if (children.count == 0 && V.self is ViewDrawable.Type){
            self.traits.animation = Transaction.current.animation
        }
    }
}

extension WindowGroup: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        return node.buildContentViewDefault(_content)
    }
}

extension _ViewModifier_Content: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        content?._buildViews(node: node)
    }
    init<T: View>(view: T) {
        content = .init(view)
    }
}
protocol _AnimationModifierAstNodeBuilder{
    func _makeAnimationModifierAstNode() -> AnyASTNode
}
extension ModifiedContent: _AnimationModifierAstNodeBuilder where Content: View, Modifier: AnimatableModifier{
    func _makeAnimationModifierAstNode() -> AnyASTNode{
        return AnimatableModifierASTNode.init(self)
    }
}
extension ModifiedContent: _CustomAnyASTNodeBuilder where Content: View, Modifier: ViewModifier{
    func _makeAstNode() -> AnyASTNode{
        let obj = self as? _AnimationModifierAstNodeBuilder
        let node: AnyASTNode = obj?._makeAnimationModifierAstNode() ?? ViewModifierASTNode.init(self)
        return node
    }
}
extension ModifiedContent: AnyASTNodeBuilder where Content: View, Modifier: ViewModifier {
    func _buildViews(node: AnyASTNode) {
        if false == type(of: self.modifier).Body is Never.Type {
            node.buildContentViewDefault(modifier.body(content: .init(view: content)))
        } else {
            if let builder = modifier as? _ViewModifierBuilder{
                builder._buildViews(node: node, content: content)
            }else{
                node.buildContentViewDefault(content)
            }
        }
        if (self.modifier is any AnimatableModifier){
            node.traits.animation = Transaction.current.animation
            node.updateAnimation()
        }
    }
}
extension AnyView: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        storage._buildViews(node: node)
    }
}
extension TupleView: AnyASTNodeBuilder{
    func _buildViews(node: AnyASTNode) {
        Mirror(reflecting: value).children.enumerated().forEach{ iter in
            let view = iter.element.value as? any View ?? EmptyView()
            node.buildContentView(view, offset: iter.offset)
        }
    }
}
extension ForEach: AnyASTNodeBuilder where Content : View {
    func _buildViews(node: AnyASTNode) {
        data.enumerated().forEach{ iter in
            var hash: AnyHashable
            switch idGenerator{
                case let .keyPath(keyPath):
                    hash = AnyHashable.init(iter.element[keyPath: keyPath])
                case .offset:
                    hash = AnyHashable.init(iter.element as! Int)
            }
            node.buildContentView(content(iter.element), id: hash)
        }
    }
}
extension VStack: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(_tree)
    }
}
extension Tree: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        node.traits.isStack = true
        node.buildContentViewDefault(content)
    }
}
extension HStack: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(_tree)
    }
}
extension ZStack: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(_tree)
    }
}
extension GeometryReader: AnyASTNodeBuilder{
    func _buildViews(node: AnyASTNode) {
        node.traits.isStack = true
    }
}
extension Group: AnyASTNodeBuilder where Group: View{
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(content)
    }
}

extension Optional: AnyASTNodeBuilder where Wrapped: View {
    func _buildViews(node: AnyASTNode) {
        if let view = self {
            node.buildContentViewDefault(view)
        }else{
            node.buildContentViewDefault(EmptyView())
        }
    }
}

extension _ConditionalContent: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        switch self._storage {
        case let .trueContent(view): node.buildContentViewDefault(view)
        case let .falseContent(view): node.buildContentViewDefault(view)
        }
    }
}
extension Button: AnyASTNodeBuilder {
    func _buildViews(node: AnyASTNode) {
        let style = node.environments._buttonStyles.last ?? DefaultButtonStyle()
        let config = PrimitiveButtonStyleConfiguration.init(_label, action: action)
        let view = style.makeBody(configuration: config)
        node.buildContentViewDefault(view)
    }
}
extension Divider: AnyASTNodeBuilder{
    func _buildViews(node: AnyASTNode) {
        let color = Color.init(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.7)
        node.buildContentViewDefault(color)
    }
}
extension PrimitiveButtonStyleConfiguration.Label: AnyASTNodeBuilder{
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(content)
    }
}
extension IDView: _ViewModifierBuilder{
    func _buildViews(node: AnyASTNode) {
        node.buildContentViewDefault(content, id: AnyHashable.init(id))
    }
}

extension _BackgroundModifier: _ViewModifierBuilder {
    func _buildViews<T: View>(node: AnyASTNode, content: T) {
        node.traits.isStack = true
        node.buildContentViewDefault(content)
    }
}
extension _OverlayModifier: _ViewModifierBuilder {
    func _buildViews<T: View>(node: AnyASTNode, content: T) {
        node.traits.isStack = true
        node.buildContentViewDefault(content)
    }
}

extension _EnvironmentKeyWritingModifier: _ViewModifierBuilder {
    func _configViews(node: AnyASTNode) {
        node.environments[keyPath: keyPath] = value
    }
}
extension _EnvironmentKeyTransformModifier: _ViewModifierBuilder{
    func _configViews(node: AnyASTNode) {
        transform(&node.environments[keyPath: keyPath]) 
    }
}
extension _TraitWritingModifier: _ViewModifierBuilder{
    func _configViews(node: AnyASTNode) {
        node.traits[Key.self] = value
    }
}

extension ButtonStyleModifier: _ViewModifierBuilder{
    func _configViews(node: AnyASTNode) {
        node.environments._buttonStyles += [style]
    }
}
extension _TransactionModifier: _ViewModifierBuilder{
    func _buildViews<T: View>(node: AnyASTNode, content: T){
        Transaction.transform(transform){
            node.buildContentViewDefault(content)
        }
    }
}

extension _AnimationModifier: _ViewModifierBuilder{
    func _buildViews<T: View>(node: AnyASTNode, content: T){
        var disablesAnimations = false

        if let old = node.children.first?.any as? _AnimationModifier{
            if (old.value == value){
                disablesAnimations = true
            }
        }
        let transform: (inout Transaction) -> () = { t in
            if (!disablesAnimations && !t.disablesAnimations){
                t.animation = animation
            }
        }
        Transaction.transform(transform){
            node.buildContentViewDefault(content)
        }
    }
}

