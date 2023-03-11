import Foundation

public struct ZStack<Content> : View where Content : View {
    var _tree: Tree<_LayoutRoot<ZStackLayout>, Content>
    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content){
        _tree = .init(root: .init(layout: .init(alignment: alignment)), content: content())

    }
    public typealias Body = Never
}

extension ZStack: _NeverPublicBody{
}

public struct ZStackLayout: Layout{
    public typealias Cache = ()

    public var alignment: Alignment

    func reduceSizeFunc(_ result: CGSize, _ size: CGSize) -> CGSize{
        var result = result
        result.width = max(result.width, size.width)
        result.height = max(result.height, size.height)
        return result
    }
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGSize{
        let result = subviews.reduce(CGSize.zero) { (result, v) in
            return reduceSizeFunc(result, v.sizeThatFits(proposal))
        }
        return result
    }
    
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache){
        subviews.forEach{ v in
            let dimensions = v.dimensions(in: proposal)
            let position = alignment.computeChildPosition(view: .init(size: bounds.size), subview: dimensions)
            v.place(at: position + bounds.origin, anchor: .topLeading, proposal: proposal)
        }
    }
}