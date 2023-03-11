import Foundation

struct _PaddingLayout: ViewModifier {
    typealias Body = Never

    var edges = Edge.Set.all
    var insets: EdgeInsets? = nil
    
    init(_ insets: EdgeInsets) {
        self.insets = insets
    }

    init(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) {
        self.edges = edges
        if let length = length{
            self.insets = EdgeInsets(top: length, leading: length, bottom: length, trailing: length)
        }
    }

    init(_ length: CGFloat) {
        self.insets = EdgeInsets(top: length, leading: length, bottom: length, trailing: length)
    }
}

extension View {
    public func padding(_ insets: EdgeInsets) -> some View {
        return modifier(_PaddingLayout(insets))
    }

    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        return modifier(_PaddingLayout(edges, length))
    }

    public func padding(_ length: CGFloat) -> some View {
        return modifier(_PaddingLayout(length))
    }
}
