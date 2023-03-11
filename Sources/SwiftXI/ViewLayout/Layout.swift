public protocol Layout : Animatable {
    static var layoutProperties: LayoutProperties { get }
    associatedtype Cache = Void
    typealias Subviews = LayoutSubviews
    func makeCache(subviews: Self.Subviews) -> Self.Cache
    func updateCache(_ cache: inout Self.Cache, subviews: Self.Subviews)

    func spacing(subviews: Self.Subviews, cache: inout Self.Cache) -> ViewSpacing

    func sizeThatFits(proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGSize
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache)
    func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?
    func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?
}

extension Layout {
    public static var layoutProperties: LayoutProperties { .init() }
    public func updateCache(_ cache: inout Self.Cache, subviews: Self.Subviews){
        cache = makeCache(subviews: subviews)
    }
    public func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?{
        return 0
    }
    public func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?{
        return 0
    }
    public func spacing(subviews: Self.Subviews, cache: inout Self.Cache) -> ViewSpacing{
        return .init()
    }
}


extension Layout where Self.Cache == () {
    public func makeCache(subviews: Self.Subviews) -> Self.Cache{
        return ()
    }
}
protocol _AnyLayoutRoot{
    associatedtype LayoutType: Layout
    var layout: LayoutType {get}
    func sizeThatFits(_ proposal: ProposedViewSize, view: _StackViewElementNode) -> CGSize
    func place(in bounds: CGRect, proposal: ProposedViewSize, view: _StackViewElementNode)
}

extension Layout {
    public func callAsFunction<V>(@ViewBuilder _ content: () -> V) -> some View where V : View{
        return EmptyView()
    }
}

struct _LayoutRoot<T: Layout>{
    var layout: T
}
extension _LayoutRoot: _AnyLayoutRoot{
    func sizeThatFits(_ proposal: ProposedViewSize, view: _StackViewElementNode) -> CGSize{
        let subviews = T.Subviews.init(view)
        var cache = layout.makeCache(subviews: subviews)
        return layout.sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
    }
    func place(in bounds: CGRect, proposal: ProposedViewSize, view: _StackViewElementNode){
        let subviews = T.Subviews.init(view)
        var cache = layout.makeCache(subviews: subviews)
        layout.placeSubviews(in: bounds, proposal: proposal, subviews: subviews, cache: &cache)
    }
}


struct Tree<T: _AnyLayoutRoot, Content: View>: View{
    var root: T
    var content: Content

    var layout: any Layout{
        return root.layout
    }
    var layoutProperties: LayoutProperties { 
        return T.LayoutType.layoutProperties
    }
}
protocol _LayoutPropertiesGetter{
    var layoutProperties: LayoutProperties {get}
}
extension Tree: _LayoutPropertiesGetter{
}

extension Tree : _NeverInternalBody{
}

public enum LayoutDirection : Hashable, CaseIterable {
    case leftToRight
    case rightToLeft

    public typealias AllCases = [LayoutDirection]
}

public struct LayoutProperties {
    public init() {}
    public var stackOrientation: Axis? = nil
}

public struct ViewSpacing {
    public static let zero: ViewSpacing = .init()
    public init(){}
 
    public mutating func formUnion(_ other: ViewSpacing, edges: Edge.Set = .all){

    }
    public func union(_ other: ViewSpacing, edges: Edge.Set = .all) -> ViewSpacing{
        return .init()
    }
    public func distance(to next: ViewSpacing, along axis: Axis) -> CGFloat{
        return 0
    }
}
