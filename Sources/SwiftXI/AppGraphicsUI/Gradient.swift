public struct Gradient : Equatable {
    public struct Stop : Equatable {
        public var color: Color
        public var location: CGFloat
        public init(color: Color, location: CGFloat){
            self.color = color
            self.location = location
        }
    }

    public var stops: [Gradient.Stop]
    public init(stops: [Gradient.Stop]){
        self.stops = stops
    }
    public init(colors: [Color]){
        var step: CGFloat = 1
        if colors.count > 1{
            step = 1.0/CGFloat(colors.count-1)
        }
        let stops = colors.enumerated().map{ Stop.init(color: $0.element, location: CGFloat($0.offset) * step) }
        
        self.init(stops: stops)
    }
}

extension Gradient : Hashable {
}

extension Gradient : ShapeStyle {
}

extension Gradient {
    public struct ColorSpace : Hashable {
        init(){}
        public static let device: Gradient.ColorSpace = .init()
        public static let perceptual: Gradient.ColorSpace = .init()
    }
    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient{
        return .init(self)
    }
}

extension Gradient.Stop : Hashable {
}

public struct AnyGradient : Hashable, ShapeStyle {
    var gradient: Gradient
    public init(_ gradient: Gradient){
        self.gradient = gradient
    }
}
extension AnyGradient {
    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient{
        return self
    }
}