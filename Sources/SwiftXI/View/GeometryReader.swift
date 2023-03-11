public struct GeometryReader<Content> : View where Content : View {
    public var content: (GeometryProxy) -> Content
    public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content){
        self.content = content
    }
    public typealias Body = Never
}

public struct GeometryProxy {
    weak var value: _ViewElementNode?  
    init(_ value: _ViewElementNode){
        self.value = value
    }
    public var size: CGSize { 
        guard let node = self.value else{
            return .zero
        }
        let geometry = node.geometry

        let width = geometry.width
        let height = geometry.height
        return .init(width: width, height: height)
     }

    // public subscript<T>(anchor: Anchor<T>) -> T { 
    // }

    // public var safeAreaInsets: EdgeInsets { get }

    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect{
        guard let node = self.value else{
            return .zero
        }
        var rect = CGRect.zero
        rect.size = self.size
        switch coordinateSpace {
            case .global: rect.origin = node.geometry.absolutePosition
            case .local: break
            case let .named(name): let _ = name
        }
        return rect
    }
}

extension GeometryReader: _NeverPublicBody{
}

