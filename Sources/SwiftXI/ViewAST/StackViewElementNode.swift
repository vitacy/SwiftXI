class _StackViewElementNode : _ViewElementNode{
    var children = [_ViewElementNode]()

    override var isStackRoot: Bool {
        return true
    }
    override func hitTestGesture(_ point: CGPoint) -> [_GestureContextValue]{
        var arr = [_GestureContextValue].init()
        children.forEach{ child in
            var result = child.hitTestGesture(point)
            result.mutatingForEach{$0.tempZIndex = child.zIndex}
            arr += result
        }
        arr += super.hitTestGesture(point)

        arr.sort{$0.tempZIndex < $1.tempZIndex}
        return arr
    }
    override func computeAbsolutePosition(_ origin: CGPoint){
        super.computeAbsolutePosition(origin)

        let lastPosition = geometry.absolutePosition
        children.forEach { child in 
            child.computeAbsolutePosition(lastPosition)
        }
    }
    override func layoutConfigView(){
        super.layoutConfigView()
        children.forEach { child in 
            child.layoutConfigView()
        }
    }

    
    func makeChildValue(node: AnyASTNode, caches: [_ViewElementNode]) -> _ViewElementNode{
        var result = caches.first{ObjectIdentifier($0.node) == ObjectIdentifier(node)}
        if result == nil {
            result = node.createViewContextValue()
        }
        result?.stack = self
        children.append(result!)
        return result!
    }
    func makeRenderTree(){
        let value = self
        let caches = children
        value.children.removeAll()
        node.children.forEach{ child in
            child.makeRenderTree(root: value, modfiers: [], caches: caches)
        }
    }
    func makeRenderTree<T: View>(content: T){
        node.buildContentViewDefault(content)
        self.makeRenderTree()
    }
}