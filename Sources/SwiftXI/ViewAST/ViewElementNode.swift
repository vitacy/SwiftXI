
protocol _ViewElementNodeCreator{
    func _viewContextCreate(node: AnyASTNode) -> _ViewElementNode
}
extension _ViewElementNodeCreator{
    func _viewContextCreate(node: AnyASTNode) -> _ViewElementNode{
        return _ViewElementNode.init(node)
    }
}

class _ViewElementNode{
    let node: AnyASTNode
    var geometry: _ViewGeometry = .init()
    var modifiers = [_ViewElementNode].init()
    weak var stack: _StackViewElementNode? = nil
    weak var view: _ViewElementNode? = nil
    var layer: _ViewAnimationLayer? = nil

    init(_ node: AnyASTNode){
        self.node = node
    }

    var isStackRoot: Bool {
        return false
    }
    var zIndex: Double{
        return node.traits.zIndex
    }

    var front: _ViewElementNode{
        return modifiers.first ?? self
    }

    func hitTestGesture(_ point: CGPoint) -> [_GestureContextValue]{
        var results = [_GestureContextValue].init()
        if !front.geometry.frameInWindow.contains(point){
            return results
        }
        
        modifiers.forEach{ m in
            results += m.hitTestGesture(point)
        }

        guard let gestureView = self.view else{
            return results
        }
        if let process = node.any as? any _DefaultGestureEventProcess{
            var gestureValue = _GestureContextValue.init(modifier: self, view: gestureView)
            process.gestureContextInit(value: &gestureValue)
            results.append(gestureValue)
        }
        
        return results
    }


    func dump(_ space: String = "", _ level: Int = 100, _ showM: Bool = true) {
        if(level == 0){
            return
        }
        print("\(space)\(node.name) +++ \(type(of:node.any))", terminator: "")
        var geometry = self.geometry
        if modifiers.count > 0 {
            geometry = modifiers.first!.geometry
        }

        print(" \(geometry.width)--\(geometry.height)", terminator: "")
        print("  \(geometry.position.x)-\(geometry.position.y)",  terminator: "")
        print("  \(geometry.absolutePosition.x)-\(geometry.absolutePosition.y)")

        if showM{
            modifiers.forEach { m in
                m.dump("\(space)++++modifier---", level, showM)
            }
        }
        
        if let stack = self as? _StackViewElementNode{
            stack.children.forEach { n in
                n.dump(space + "----",  level-1, showM)
            }
        }
    }
    func dumpPosition(_ space: String = "") {
        print("\(space)\(node.name)", terminator: "")
        print(" \(geometry.position) --- \(geometry.width) \(geometry.height) ")
        if let stack = self as? _StackViewElementNode{
            stack.children.forEach { n in
                n.dumpPosition(space + "----")
            }
        }
    }
    var layoutComputer: ComputableLayout{
        return (node.any as? ComputableLayout) ?? ComputeLayoutDefault()
    }

    func computeAbsolutePosition(_ origin: CGPoint) {
        var lastPosition = origin
        modifiers.forEach{ m in
            m.computeAbsolutePosition(lastPosition)
            lastPosition = m.geometry.absolutePosition
        }
        
        lastPosition = lastPosition + geometry.frame.origin
        geometry.absolutePosition = lastPosition
    }
    func layoutConfigView(){
        modifiers.forEach{ m in
            m.layoutConfigView()
        }
        let obj = layoutComputer
        obj.layoutConfigView(value: self)
    }
    
    func layout(size: CGSize){
        self.place(at: .zero, proposal: .init(size))
        computeAbsolutePosition(.zero)
        layoutConfigView()
    }

    func updateModifiers(nodes: [AnyASTNode]){
        var modifiers = [_ViewElementNode].init()
        if self.modifiers.count == 0 {
            nodes.forEach{ node in
                if let value = node.createModifierContextValue(){
                    value.view = self
                    modifiers.append(value)
                }
            }
            self.modifiers = modifiers
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize{
        let proxy = _LayoutNodeProxy.init(node: self)
        return proxy.sizeThatFits(proposal)
    }
    func dimensions(in proposal: ProposedViewSize) -> ViewDimensions{
        let proxy = _LayoutNodeProxy.init(node: self)
        return proxy.dimensions(in: proposal)
    }
    func place(at position: CGPoint, anchor: UnitPoint = .topLeading, proposal: ProposedViewSize){
        let proxy = _LayoutNodeProxy.init(node: self)
        proxy.place(at: position, anchor: anchor, proposal: proposal)
    }
}

struct _LayoutNodeProxy{
    var node: _ViewElementNode
    var index: Int = 0

    var child: Self?{
        if index >= node.modifiers.count{
            return nil
        }
        return .init(node: node, index: index+1)
    }
    var current: _ViewElementNode{
        if index >= node.modifiers.count{
            return node
        }
        return node.modifiers[index]
    }
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize{
        return current.layoutComputer.sizeThatFits(proposal, proxy: self)
    }
    func dimensions(in proposal: ProposedViewSize) -> ViewDimensions{
        let size = sizeThatFits(proposal)
        return ViewDimensions.init(size: size)
    }
    func place(at position: CGPoint, anchor: UnitPoint = .topLeading, proposal: ProposedViewSize){
        let layoutComputer = current.layoutComputer
        layoutComputer.place(at: position, anchor: anchor, proposal: proposal, proxy: self)
    }
}

