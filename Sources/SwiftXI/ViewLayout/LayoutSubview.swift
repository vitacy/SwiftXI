public struct LayoutSubview : Equatable {
    var node: _ViewElementNode
    var astNode: AnyASTNode{
        return node.node
    }
    public subscript<K>(key: K.Type) -> K.Value where K : LayoutValueKey {
        return astNode.traits[key]
    }
    public var priority: Double { astNode.traits.layoutPriority }
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize{
        return node.sizeThatFits(proposal)
    }
    public func dimensions(in proposal: ProposedViewSize) -> ViewDimensions{
        return node.dimensions(in: proposal)
    }
    public var spacing: ViewSpacing { return .init() }
    public func place(at position: CGPoint, anchor: UnitPoint = .topLeading, proposal: ProposedViewSize){
        node.place(at: position, anchor: anchor, proposal: proposal)
    }
    public static func == (a: LayoutSubview, b: LayoutSubview) -> Bool{
        return a.node === b.node
    }
}

public struct LayoutSubviews : Equatable, RandomAccessCollection {
    public typealias SubSequence = LayoutSubviews
    public typealias Element = LayoutSubview
    public typealias Index = Int

    var node: _StackViewElementNode
    var _indices: Array<Int>

    init(_ node: _StackViewElementNode, indices: Array<Int>){
        self.node = node
        self._indices = indices
    }
    init(_ node: _StackViewElementNode){
        self.node = node
        _indices = .init(node.children.indices)
    }

    public var layoutDirection: LayoutDirection = .leftToRight
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return _indices.count }

    public subscript(index: Int) -> LayoutSubviews.Element { 
        return .init(node: node.children[index])
    }
    public subscript(bounds: Range<Int>) -> LayoutSubviews { 
        return .init(node, indices: Array<Int>(_indices[bounds]))
    }
    public subscript<S>(indices: S) -> LayoutSubviews where S : Sequence, S.Element == Int { 
        return .init(node, indices: Array<Int>(indices.map{_indices[$0]}))
    }
    public static func == (lhs: LayoutSubviews, rhs: LayoutSubviews) -> Bool{
        return lhs.node === rhs.node && lhs.indices == rhs.indices
    }

    public typealias Indices = Range<LayoutSubviews.Index>
    public typealias Iterator = IndexingIterator<LayoutSubviews>
}


public protocol LayoutValueKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}