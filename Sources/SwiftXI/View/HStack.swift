import Foundation

public struct HStack<Content>: View where Content: View {
    var _tree: Tree<_LayoutRoot<HStackLayout>, Content>
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        _tree = .init(root: .init(layout: .init(alignment: alignment, spacing: spacing)), content: content())
    }
    public typealias Body = Never
}

extension HStack : _NeverPublicBody{
}
public struct HStackLayout: Layout{
    var alignment: VerticalAlignment
    var spacing: CGFloat?

    public static var layoutProperties: LayoutProperties { 
        var properties = LayoutProperties.init()
        properties.stackOrientation = .some(.horizontal)
        return properties
    }
    public typealias Cache = ()
    static func reduceSizeFunc(_ result: CGSize, _ size: CGSize) -> CGSize{
        var result = result
        result.height = max(result.height, size.height)
        result.width += size.width
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
            result = proposal.replacingUnspecifiedDimensions()
            result.width -= totalSpace
            result = result.replacing(minSize: .zero)
            let minSize = subviews.reduce(CGSize.zero) { (value, v) in
                return Self.reduceSizeFunc(value, v.sizeThatFits(.init(width: 0, height: result.height)))
            }
            let maxSize = subviews.reduce(CGSize.zero) { (value, v) in
                return Self.reduceSizeFunc(value, v.sizeThatFits(.init(result)))
            }
            result = result.replacing(minSize){$0 < $1}.replacing(maxSize){$0 > $1}
        }
        
        result.width += totalSpace
        return result
    }
    
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache){
        var totalSpace = CGFloat.zero
        let space = self.spacing ?? Spacer.defaultSpacing
        if (subviews.count > 0){
            totalSpace = space * CGFloat(subviews.count - 1)
        }
        var computer = _StackLayoutComputer.init(_HStackLayoutChooser.init())
        computer.size = bounds.size
        computer.limits = .init(repeating: .init(), count: subviews.count)
        computer.computeSubviewsLimits(subviews: subviews)
        
        let usedLength = computer.limits.reduce(totalSpace){ $0 + $1.size.width }
        computer.freeLength = bounds.size.width - usedLength
        
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
            size.height = bounds.height

            let proposal = ProposedViewSize.init(size)
            let dimensions = v.dimensions(in: proposal)
            let alignment = Alignment.init(horizontal: .center, vertical: alignment)
            let position = alignment.computeChildPosition(view: .init(size: size), subview: dimensions)
            v.place(at: position+point, anchor: .topLeading, proposal: proposal)
            point.x += dimensions.width + space
        }
    }
}



    