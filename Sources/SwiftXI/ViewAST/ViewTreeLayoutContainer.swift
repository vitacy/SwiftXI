
extension Tree: ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        return root.sizeThatFits(proposal, view: proxy.current as! _StackViewElementNode)
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let bounds = proxy.current.geometry.bounds
        root.place(in: bounds, proposal: proposal, view: proxy.current as! _StackViewElementNode)
    }
}
extension WindowGroup: ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        let root: _LayoutRoot<VStackLayout> = .init(layout: .init(alignment: .center))
        return root.sizeThatFits(proposal, view: proxy.current as! _StackViewElementNode)
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let root: _LayoutRoot<VStackLayout> = .init(layout: .init(alignment: .center))
        let bounds = proxy.current.geometry.bounds
        root.place(in: bounds, proposal: proposal, view: proxy.current as! _StackViewElementNode)
    }
}
extension GeometryReader: ComputableLayout {
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        return proposal.replacingUnspecifiedDimensions()
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let value = proxy.current
        let proxy = GeometryProxy.init(value)
        let view = content(proxy)

        let stack = value as! _StackViewElementNode
        stack.makeRenderTree(content: view)

        let root: _LayoutRoot<ZStackLayout> = .init(layout: .init(alignment: .topLeading))

        let bounds = stack.geometry.bounds
        root.place(in: bounds, proposal: proposal, view: stack)
    }
}
extension _BackgroundModifier: ComputableLayout{
    func _viewContextCreate(node: AnyASTNode) -> _ViewElementNode{
        let node = node.copy()
        let value = _StackViewElementNode.init(node)
        value.makeRenderTree(content: VStack{background})
        value.children.forEach { child in 
            child.node.traits.zIndex = -0.01
        }
        return value
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        ComputeLayoutDefault().placeSubview(proposal: proposal, proxy: proxy)
        let root: _LayoutRoot<ZStackLayout> = .init(layout: .init(alignment: alignment))
        let bounds = proxy.current.geometry.bounds
        root.place(in: bounds, proposal: proposal, view: proxy.current as! _StackViewElementNode)
    }
}

extension _OverlayModifier: ComputableLayout{
    func _viewContextCreate(node: AnyASTNode) -> _ViewElementNode{
        let node = node.copy()
        let value = _StackViewElementNode.init(node)
        value.makeRenderTree(content: VStack{overlay})
        return value
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        ComputeLayoutDefault().placeSubview(proposal: proposal, proxy: proxy) 
        let root: _LayoutRoot<ZStackLayout> = .init(layout: .init(alignment: alignment))
        let bounds = proxy.current.geometry.bounds
        root.place(in: bounds, proposal: proposal, view: proxy.current as! _StackViewElementNode)
    }
}