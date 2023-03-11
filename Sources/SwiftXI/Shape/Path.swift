import Foundation

protocol AnyPathBox {
    var boundingRect: CGRect {
        get
    }
}
public struct Path: Equatable, LosslessStringConvertible {
    public typealias Element = CGPath.Element
    struct TrimmedPath: Equatable {
        let path: Path
        let from: CGFloat
        let to: CGFloat
    }

    struct StrokedPath: Equatable {
        let path: Path
        let style: StrokeStyle

        public init(path: Path, style: StrokeStyle) {
            self.path = path
            self.style = style
        }
    }
    struct PathBox: Equatable {
        var cgPath: CGMutablePath
    }
    enum Storage: Equatable {
        case empty
        indirect case stroked(StrokedPath)
        indirect case trimmed(TrimmedPath)
        case path(Path.PathBox)
        func forEach(_ body: (Path.Element) -> Void) {
            switch self {
            case .empty: break
            case .trimmed(let path): path.path.forEach(body)
            case .stroked(let path): path.path.forEach(body)
            case .path(let path): path.cgPath.forEach(body)
            }
        }
    }
    var storage: Path.Storage

    public init() {
        storage = .empty
    }

    public init(_ path: CGPath) {
        if path.isEmpty {
            storage = .empty
        } else {
            storage = .path(.init(cgPath: path.mutableCopy()!))
        }
    }
    public init(_ path: CGMutablePath) {
        self.init(path as CGPath)
    }
    mutating func convertToPathBox() {
        if case .path(_) = storage {
            return
        }
        let cgPath = CGMutablePath.init()
        self.forEach { e in
            cgPath._addElement(e)
        }
        storage = .path(.init(cgPath: cgPath))
    }
    public init(_ rect: CGRect) {
        self.init()
        self.addRect(rect)
    }

    public init(roundedRect rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .circular) {
        self.init()
        self.addRoundedRect(in: rect, cornerSize: cornerSize, style: style)
    }

    public init(roundedRect rect: CGRect, cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {
        self.init(roundedRect: rect, cornerSize: .init(width: cornerRadius, height: cornerRadius), style: style)
    }

    public init(ellipseIn rect: CGRect) {
        self.init()
        self.addEllipse(in: rect)
    }

    public init(_ callback: (inout Path) -> Void) {
        self.init()
        callback(&self)
    }
    public var cgPath: CGPath {
        if case .path(let path) = storage {
            return path.cgPath.copy()!
        }
        let path = CGMutablePath()
        self.forEach { e in
            path._addElement(e)
        }
        return path
    }

    public var isEmpty: Bool {
        return storage == .empty
    }

    public var boundingRect: CGRect {
        guard case .path(let path) = storage else {
            return .zero
        }
        return path.cgPath.boundingBox
    }

    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool {
        guard case .path(let path) = storage else {
            return false
        }
        return path.cgPath.contains(p, using: eoFill ? .evenOdd : .winding, transform: .identity)
    }

    public func forEach(_ body: (Path.Element) -> Void) {
        storage.forEach(body)
    }
    public func strokedPath(_ style: StrokeStyle) -> Path {
        var path = Path.init()
        path.storage = .stroked(.init(path: .init(self.cgPath), style: style))
        return path
    }
    public func trimmedPath(from: CGFloat, to: CGFloat) -> Path {
        return .init(self.cgPath)
    }
}

extension Path: Shape {
    public func path(in _: CGRect) -> Path {
        return self
    }
}

extension Path {
    public mutating func move(to p: CGPoint) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.move(to: p)
    }
    public mutating func addLine(to p: CGPoint) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addLine(to: p)
    }
    public mutating func addQuadCurve(to p: CGPoint, control cp: CGPoint) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addQuadCurve(to: p, control: cp)
    }
    public mutating func addCurve(to p: CGPoint, control1 cp1: CGPoint, control2 cp2: CGPoint) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addCurve(to: p, control1: cp1, control2: cp2)
    }
    public mutating func closeSubpath() {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.closeSubpath()
    }
    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addRect(rect, transform: transform)
    }
    public mutating func addRoundedRect(
        in rect: CGRect,
        cornerSize: CGSize,
        style: RoundedCornerStyle = .circular,
        transform: CGAffineTransform = .identity
    ) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath._addRoundedRect(in: rect, cornerSize: cornerSize, style: style, transform: transform)
    }
    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addRects(rects, transform: transform)
    }

    public mutating func addLines(_ lines: [CGPoint]) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addLines(between: lines)
    }
    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addEllipse(in: rect, transform: transform)
    }

    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addRelativeArc(center: center, radius: radius, startAngle: startAngle.radians, delta: delta.radians, transform: transform)
    }
    public mutating func addArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: Angle,
        endAngle: Angle,
        clockwise: Bool,
        transform: CGAffineTransform = .identity
    ) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle.radians,
            endAngle: endAngle.radians,
            clockwise: clockwise,
            transform: transform
        )
    }
    public mutating func addArc(tangent1End p1: CGPoint, tangent2End p2: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) {
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addArc(tangent1End: p1, tangent2End: p2, radius: radius, transform: transform)
    }

    public mutating func addPath(_ path: Path, transform: CGAffineTransform = .identity) {
        if path.isEmpty {
            return
        }
        convertToPathBox()
        guard case .path(let path) = storage else {
            return
        }
        path.cgPath.addPath(path.cgPath)
    }

    public var currentPoint: CGPoint? {
        guard case .path(let path) = storage else {
            return nil
        }
        return path.cgPath._currentPoint
    }

    public func applying(_ transform: CGAffineTransform) -> Path {
        var path = Path.init()
        self.forEach { e in
            switch e {
            case let .move(to: p): path.move(to: p.applying(transform))
            case let .line(to: p): path.addLine(to: p.applying(transform))
            case let .quadCurve(to: p, control: cp):
                path.addQuadCurve(to: p.applying(transform), control: cp.applying(transform))
            case let .curve(to: p, control1: cp1, control2: cp2):
                path.addCurve(to: p.applying(transform), control1: cp1.applying(transform), control2: cp2.applying(transform))
            case .closeSubpath: path.closeSubpath()
            }
        }
        return path
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Path {
        return self.applying(.init(translationX: dx, y: dy))
    }
}


extension Angle: Animatable {
    @inlinable public static var zero: Angle {
        return .init(degrees: 0)
    }
    public typealias AnimatableData = Double
    public var animatableData: Double {
        get {return radians} 
        set {radians = newValue}
    }
}


extension Path{
    public init?(_ string: String) {
        var nums: [CGFloat] = .init()
        var path = Path.init()
        for str in string.split(separator: " "){
            if str.count == 1{
                switch str.first!{
                    case "m": 
                    if nums.count == 2{
                        let p = CGPoint.init(x: nums[0], y: nums[1])
                        path.move(to: p)
                        nums.removeAll()
                        continue
                    }
                    return nil
                    
                    case "l": 
                    if nums.count == 2{
                        let p = CGPoint.init(x: nums[0], y: nums[1])
                        path.addLine(to: p)
                        nums.removeAll()
                        continue
                    }
                    return nil
                    case "q": 
                    if nums.count == 4{
                        let p = CGPoint.init(x: nums[2], y: nums[3])
                        let cp = CGPoint.init(x: nums[0], y: nums[1])
                        path.addQuadCurve(to: p, control: cp)
                        nums.removeAll()
                        continue
                    }
                    return nil
                    case "c": 
                    if nums.count == 6{
                        let p = CGPoint.init(x: nums[4], y: nums[5])
                        let cp1 = CGPoint.init(x: nums[0], y: nums[1])
                        let cp2 = CGPoint.init(x: nums[2], y: nums[3])
                        path.addCurve(to: p, control1: cp1, control2: cp2)
                        nums.removeAll()
                        continue
                    }
                    return nil
                    case "h": 
                    if nums.count == 0{
                        path.closeSubpath()
                        continue
                    }
                    return nil
                    default: break
                }
            }
            if let num = Double(str) {
                if num.isNaN {
                    return nil
                }
                nums.append(num)
                continue
            }
            return nil
        }
        self.storage = path.storage
    }
    public var description: String {
        var str = ""
        var space = ""
        self.forEach { e in
            switch e {
            case let .move(to: p): str += "\(space)\(p.x) \(p.y) m"
            case let .line(to: p): str += "\(space)\(p.x) \(p.y) l"
            case let .quadCurve(to: p, control: cp): str += "\(space)\(cp.x) \(cp.y) \(p.x) \(p.y) q"
            case let .curve(to: p, control1: cp1, control2: cp2):
                str += "\(space)\(cp1.x) \(cp1.y) \(cp2.x) \(cp2.y) \(p.x) \(p.y) c"
            case .closeSubpath: str += "\(space)h"
            }
            space = " "
        }
        return str
    }
}