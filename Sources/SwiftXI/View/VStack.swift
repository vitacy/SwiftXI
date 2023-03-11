import Foundation

public struct VStack<Content>: View where Content: View {
    var _tree: Tree<_LayoutRoot<VStackLayout>, Content>
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        _tree = .init(root: .init(layout: .init(alignment: alignment, spacing: spacing)), content: content())
    }
    public typealias Body = Never
}

extension VStack : _NeverPublicBody{
}

public struct VStackLayout: Layout{
    public var alignment: HorizontalAlignment
    public var spacing: CGFloat?

    public static var layoutProperties: LayoutProperties { 
        var properties = LayoutProperties.init()
        properties.stackOrientation = .some(.vertical)
        return properties
    }
    public typealias Cache = ()
    static func reduceSizeFunc(_ result: CGSize, _ size: CGSize) -> CGSize{
        var result = result
        result.width = max(result.width, size.width)
        result.height += size.height
        return result
    }
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGSize{
        var result = CGSize.zero
        var totalSpace = CGFloat.zero
        if (subviews.count > 0){
            let space = self.spacing ?? Spacer.defaultSpacing
            totalSpace = space * CGFloat(subviews.count - 1)
        }
        switch proposal{
        case .zero, .infinity, .unspecified:
            result = subviews.reduce(CGSize.zero) { (result, v) in
                return Self.reduceSizeFunc(result, v.sizeThatFits(proposal))
            }
        default:
            let size = proposal.replacingUnspecifiedDimensions()
            let minSize = subviews.reduce(CGSize.zero) { (result, v) in
                return Self.reduceSizeFunc(result, v.sizeThatFits(.init(width: size.width, height: 0)))
            }
            let maxProposal = ProposedViewSize.init(width: size.width, height: max(size.height-totalSpace, 0))
            let maxSize = subviews.reduce(CGSize.zero) { (result, v) in
                return Self.reduceSizeFunc(result, v.sizeThatFits(maxProposal))
            }
            result.width = min(max(minSize.width, size.width), maxSize.width)
            result.height = min(max(minSize.height, size.height), maxSize.height)
        }
        
        result.height += totalSpace
        return result
    }
    
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache){
        var totalSpace = CGFloat.zero
        let space = self.spacing ?? Spacer.defaultSpacing
        if (subviews.count > 0){
            totalSpace = space * CGFloat(subviews.count - 1)
        }
        var computer = _StackLayoutComputer.init()
        computer.size = bounds.size
        computer.limits = .init(repeating: .init(), count: subviews.count)
        computer.computeSubviewsLimits(subviews: subviews)
        
        let usedLength = computer.limits.reduce(totalSpace){ $0 + $1.size.height }
        computer.freeLength = bounds.size.height - usedLength
        
        while true{
            computer.computeCurrentPriority()
            computer.computeSubviewsIndices(subviews: subviews)
            computer.computeSubviewsSize()

            if computer.isFinished{
                break
            }
        }
        
        var point = bounds.origin
        subviews.enumerated().forEach{ (offset, v) in
            var size = computer.limits[offset].size
            size.width = bounds.width

            let proposal = ProposedViewSize.init(size)
            let dimensions = v.dimensions(in: proposal)
            let alignment = Alignment.init(horizontal: alignment, vertical: .center)
            let position = alignment.computeChildPosition(view: .init(size: size), subview: dimensions)
            v.place(at: position+point, anchor: .topLeading, proposal: proposal)
            point.y += dimensions.height + space
        }
    }
}



    