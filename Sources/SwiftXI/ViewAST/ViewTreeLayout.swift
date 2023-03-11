import Foundation

protocol ComputableLayout: _ViewElementNodeCreator {  
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize
    func place(at position: CGPoint, anchor: UnitPoint, proposal: ProposedViewSize, proxy: _LayoutNodeProxy)
    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy)

    func layoutConfigView(value: _ViewElementNode)
}
struct ComputeLayoutDefault: ComputableLayout {
}


extension ComputableLayout {
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        return proxy.child?.sizeThatFits(proposal) ?? .zero
    }

    func placeSubview(proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        proxy.child?.place(at: .zero, anchor: .topLeading, proposal: .init(proxy.current.geometry.size))
    }
    func place(at position: CGPoint, anchor: UnitPoint, proposal: ProposedViewSize, proxy: _LayoutNodeProxy){
        let dimensions = proxy.dimensions(in: proposal)
        proxy.current.geometry.position = position
        proxy.current.geometry.anchorPoint = anchor
        proxy.current.geometry.size = .init(width: dimensions.width, height: dimensions.height)
        placeSubview(proposal: proposal, proxy: proxy)
    }
 
    func layoutConfigView(value: _ViewElementNode){

    }
    func defaultLayoutConfigView(value: _ViewElementNode){
        if (value.layer == nil){
            value.layer = _ViewAnimationLayer.init()
            value.layer?.value = value
            value.layer?.frame = value.geometry.frameInWindow
        }
        value.layer?.withAnimation{ v in
            v.frame = value.geometry.frameInWindow
        }
    }
}

struct _ViewGeometry {
    var width: CGFloat = 0
    var height: CGFloat = 0

    var position = CGPoint.zero
    var anchorPoint = UnitPoint.zero
    var absolutePosition = CGPoint.zero
}

extension _ViewGeometry{
    var size: CGSize{
        get {
            return .init(width: width, height: height)
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    var bounds: CGRect{
        return .init(origin: .zero, size: size)
    }
    var frame: CGRect{
        let anchor = bounds.anchorPoint(anchor: anchorPoint)
        return .init(origin: position - anchor, size: .init(width: width, height: height))
    }
    var frameInWindow: CGRect{
        return .init(origin: absolutePosition, size: .init(width: width, height: height))
    }
}

