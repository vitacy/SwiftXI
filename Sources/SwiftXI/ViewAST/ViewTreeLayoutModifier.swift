extension _PaddingLayout: ComputableLayout {
    static let defaultPadding: CGFloat = 16
    func getResultInsets() -> EdgeInsets {
        let defaultPadding = Self.defaultPadding
        var insets = self.insets ?? .init(top: defaultPadding, leading: defaultPadding, bottom: defaultPadding, trailing: defaultPadding)
        if edges != .all {
            if !edges.contains(.leading) {
                insets.leading = 0
            }
            if !edges.contains(.trailing) {
                insets.trailing = 0
            }
            if !edges.contains(.top) {
                insets.top = 0
            }
            if !edges.contains(.bottom) {
                insets.bottom = 0
            }
        }
        return insets
    }

    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        var size = CGSize.init()
        let insets = getResultInsets()
        size.width += insets.trailing + insets.leading
        size.height += insets.top + insets.bottom

        switch proposal{
            case .zero, .infinity, .unspecified:
                size += ComputeLayoutDefault().sizeThatFits(proposal, proxy: proxy)
            default:
                var subviewSize = proposal.replacingUnspecifiedDimensions(by: .zero)
                subviewSize -= size
                subviewSize = subviewSize.replacing(minSize: .zero)
                size += ComputeLayoutDefault().sizeThatFits(.init(subviewSize), proxy: proxy)
        }
        return size
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let insets = getResultInsets()
        let paddingSize = CGSize.init(width: insets.trailing + insets.leading, height: insets.top + insets.bottom)
        var subviewSize = proxy.current.geometry.size - paddingSize
        subviewSize = subviewSize.replacing(minSize: .zero)

        proxy.child?.place(at: .init(x: insets.leading, y: insets.top), anchor: .topLeading, proposal: .init(subviewSize))
    }

}

extension _FrameLayout : ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        var result = CGSize.zero
        switch (width, height){
        case (.some(let width), .some(let height)): 
            result = .init(width: width, height: height) 
        default:
            var proposal = proposal
            width.map{proposal.width = $0}
            height.map{proposal.height = $0}
            result = ComputeLayoutDefault().sizeThatFits(proposal, proxy: proxy) 
            width.map{result.width = $0}
            height.map{result.height = $0}
        }
        return result
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let viewSize = proxy.current.geometry.size
        let proposal = ProposedViewSize.init(viewSize)
        let subviewSize = proxy.child!.sizeThatFits(proposal)
        let position = alignment.computeChildPosition(viewSize: viewSize, subviewSize: subviewSize)
        proxy.child?.place(at: position, anchor: .topLeading, proposal: proposal)
    }
}
extension _FlexFrameLayout: ComputableLayout {
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        var result = CGSize.zero

        var childProposal = proposal
        switch proposal.width{
            case .none: 
                idealWidth.map{childProposal.width = $0}
            case var .some(value):
                minWidth.map{value = max($0, value)}
                maxWidth.map{value = min($0, value)}
                childProposal.width = value
        }
        switch proposal.height{
            case .none: 
                idealHeight.map{childProposal.height = $0}
            case var .some(value):
                minHeight.map{value = max($0, value)}
                maxHeight.map{value = min($0, value)}
                childProposal.height = value
        }
        result = ComputeLayoutDefault().sizeThatFits(childProposal, proxy: proxy) 
        switch proposal.width{
            case .none: 
                idealWidth.map{result.width = $0}
            case var .some(value):
                minWidth.map{value = max($0, value)}
                maxWidth.map{value = min($0, value)}
                result.width = value
        }
        switch proposal.height{
            case .none: 
                idealHeight.map{result.height = $0}
            case var .some(value):
                minHeight.map{value = max($0, value)}
                maxHeight.map{value = min($0, value)}
                result.height = value
        }
        return result
    }
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let viewSize = proxy.current.geometry.size
        let proposal = ProposedViewSize.init(viewSize)
        let subviewSize = proxy.child!.sizeThatFits(proposal)
        let position = alignment.computeChildPosition(viewSize: viewSize, subviewSize: subviewSize)
        proxy.child?.place(at: position, anchor: .topLeading, proposal: proposal)
    }
}

extension _AspectRatioLayout: ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        let ratio = aspectRatio ?? {
            let size = ComputeLayoutDefault().sizeThatFits(.unspecified, proxy: proxy)
            return size.width/max(size.height, 0.1)
        }()
        var proposal = proposal
        switch proposal{
            case .unspecified: break
            default:
                var bounds = CGRect.zero
                bounds.size = proposal.replacingUnspecifiedDimensions(by: .zero)
                bounds = contentMode == .fit ? bounds.scale(fit: ratio) : bounds.scale(fill: ratio)
                proposal = .init(bounds.size)
        }
        return ComputeLayoutDefault().sizeThatFits(proposal, proxy: proxy)
    }
}
extension _OffsetEffect: ComputableLayout{
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let position = CGPoint.init(x: offset.width, y: offset.height)
        proxy.child?.place(at: position, anchor: .topLeading, proposal: .init(proxy.current.geometry.size))
    }
}

extension _PositionLayout: ComputableLayout{
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let value = proxy.current
        let ctx = value.geometry
        proxy.child?.place(at: position - ctx.bounds.centerPoint, anchor: .topLeading, proposal: .init(value.geometry.size))
    }
}

extension _FixedSizeLayout: ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        var proposal = proposal
        if horizontal{
            proposal.width = nil
        }
        if vertical{
            proposal.height = nil
        }
        return ComputeLayoutDefault().sizeThatFits(proposal, proxy: proxy)
    }
}
extension _HoverRegionModifier: ComputableLayout{
    class _EventCtxData{
        var installed = false
        var hited = false
        init(){}
    }
    func layoutConstraint(value: _ViewElementNode) {
        var itemData = value.node.traits._eventCtxData

        if (itemData == nil){
            itemData = _EventCtxData()
            value.node.traits._eventCtxData = itemData
        }
        
        guard let itemData = itemData else{
            return
        }
        guard let window = value.node.getWindow() else{
            return
        }
        if !itemData.installed {
            itemData.installed = true
            window.trackEvent(matching: .mouseMoved, until: .distantFuture) { (event, _) in 
                let hited = value.geometry.frameInWindow.contains(event.locationInWindow)
                if (hited != itemData.hited){
                    itemData.hited = hited
                    callback(hited)
                }
            }
        }  
    }
}
extension _ScrollWheelEventModifier: ComputableLayout{
    func layoutConstraint(value: _ViewElementNode) {
        var itemData = value.node.traits._eventCtxData

        if (itemData == nil){
            itemData = _HoverRegionModifier._EventCtxData()
            value.node.traits._eventCtxData = itemData
        }

        guard let itemData = itemData else{
            return
        }

        guard let window = value.node.getWindow() else{
            return
        }
        if !itemData.installed {
            itemData.installed = true
            window.trackEvent(matching: .scrollWheel, until: .distantFuture) { (event, _) in 
                if value.geometry.frameInWindow.contains(event.locationInWindow){
                    callback(.init(width: event.deltaX, height: event.deltaY))
                }
            }
        }
    }
}