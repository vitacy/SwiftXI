import Foundation

public class CGPath {
    public enum Element: Equatable {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case closeSubpath
    }
    
    var elements: [Element]
    init() {
        elements = .init()
    }
}
public final class CGMutablePath: CGPath {
    public override init() {
    }
}
extension CGPath: Equatable {
    public static func == (lhs: CGPath, rhs: CGPath) -> Bool {
        return lhs.elements == rhs.elements
    }
}
extension CGMutablePath {
    public func closeSubpath() {
        elements.append(.closeSubpath)
    }
    public func addRoundedRect(in rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: CGAffineTransform = .identity) {
        self._addRoundedRect(in: rect, cornerSize: CGSize.init(width: cornerWidth, height: cornerHeight), style: .circular, transform: transform)
    }

    public func move(to point: CGPoint, transform: CGAffineTransform = .identity) {
        elements.append(.move(to: point))
    }

    public func addLine(to point: CGPoint, transform: CGAffineTransform = .identity) {
        elements.append(.line(to: point))
    }

    public func addQuadCurve(to end: CGPoint, control: CGPoint, transform: CGAffineTransform = .identity) {
        elements.append(.quadCurve(to: end, control: control))
    }

    public func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint, transform: CGAffineTransform = .identity) {
        elements.append(.curve(to: end, control1: control1, control2: control2))
    }

    public func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
        let es: [Element] = [
            .move(to: CGPoint(x: rect.minX, y: rect.minY)),
            .line(to: CGPoint(x: rect.maxX, y: rect.minY)),
            .line(to: CGPoint(x: rect.maxX, y: rect.maxY)),
            .line(to: CGPoint(x: rect.minX, y: rect.maxY)),
            .closeSubpath,
        ]
        elements.append(contentsOf: es)
    }

    public func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
        rects.forEach { rect in
            self.addRect(rect, transform: transform)
        }
    }

    public func addLines(between points: [CGPoint], transform: CGAffineTransform = .identity) {
        points.forEach { p in
            self.addLine(to: p, transform: transform)
        }
    }

    public func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
        let cornerSize = CGSize.init(width: rect.width * 0.5, height: rect.height * 0.5)
        self._addRoundedRect(in: rect, cornerSize: cornerSize, style: .continuous, transform: transform)
    }

    public func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, delta: CGFloat, transform: CGAffineTransform = .identity) {
        self._addArcLine(center: center, radius: radius, startRadians: startAngle, delta: -delta)
    }

    public func addArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        clockwise: Bool,
        transform: CGAffineTransform = .identity
    ) {
        var radians = Double.pi * 2 - abs(endAngle - startAngle)
        if !clockwise {
            radians = -(Double.pi * 2 - radians)
        }
        self._addArcLine(center: center, radius: radius, startRadians: startAngle, delta: radians)
    }

    public func addArc(tangent1End p1: CGPoint, tangent2End p2: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) {
        let curPoint = self.currentPoint

        let l0 = 0.00001  //minimal length
        let a0 = 1.0  //minimal angle

        let line1 = curPoint.distence(to: p1)
        let line2 = p1.distence(to: p2)
        let line3 = p2.distence(to: curPoint)
        if abs(line1) < l0 {
            return
        }
        if abs(line2) < l0 {
            self.addLine(to: p1)
            return
        }
        let kLine2 = (line2 + (line1 * line1 - line3 * line3) / line2) * 0.5
        //let kLine1 = (line1 + (line2*line2 - line3*line3)/line1)*0.5
        let angle = acos(kLine2 / line1) * 0.5
        if angle < a0 || angle > Double.pi * 0.5 - a0 {
            self.addLine(to: p1)
            return
        }
        let k = radius / tan(angle)
        let start = p1.move(percent: k / line1, to: curPoint)
        let end = p1.move(percent: k / line2, to: p2)

        let p2x = p1.move(percent: line1 / line2, to: p2)
        let pointLine3Middle = p2x.middle(between: curPoint)
        let k2 = radius / sin(angle)
        let center = p1.move(distence: k2, to: pointLine3Middle)

        self.addLine(to: start)
        self._addArcLine(center: center, start: start, end: end)
    }

    public func addPath(_ path: CGPath, transform: CGAffineTransform = .identity) {
        self.elements.append(contentsOf: path.elements)
    }
}

public enum CGLineJoin: Int32 {
    case miter = 0
    case round = 1
    case bevel = 2
}
public enum CGLineCap: Int32 {
    case butt = 0
    case round = 1
    case square = 2
}
public enum CGPathFillRule: Int {
    case winding
    case evenOdd
}
extension CGPathFillRule: Hashable {
}
extension CGPathFillRule: RawRepresentable {
}

extension CGPath {
    public func copy(dashingWithPhase phase: CGFloat, lengths: [CGFloat], transform: CGAffineTransform = .identity) -> CGPath {
        return self.copy()!
    }

    public func copy(
        strokingWithWidth lineWidth: CGFloat,
        lineCap: CGLineCap,
        lineJoin: CGLineJoin,
        miterLimit: CGFloat,
        transform: CGAffineTransform = .identity
    ) -> CGPath {
        return self.copy()!
    }

    public func copy() -> CGPath? {
        let path = CGPath()
        path.elements = self.elements
        return path
    }

    public func copy(using transform: UnsafePointer<CGAffineTransform>?) -> CGPath? {
        return self.copy()
    }

    public func mutableCopy() -> CGMutablePath? {
        let path = CGMutablePath()
        path.elements = self.elements
        return path
    }

    public func mutableCopy(using transform: UnsafePointer<CGAffineTransform>?) -> CGMutablePath? {
        return self.mutableCopy()
    }

    public convenience init(rect: CGRect, transform: UnsafePointer<CGAffineTransform>?) {
        self.init()
        let temp = CGMutablePath.init()
        temp.addRect(rect, transform: transform != nil ? transform!.pointee : .identity)
        self.elements = temp.elements
    }
    public convenience init(ellipseIn rect: CGRect, transform: UnsafePointer<CGAffineTransform>?) {
        self.init()
        let temp = CGMutablePath.init()
        temp.addEllipse(in: rect, transform: transform != nil ? transform!.pointee : .identity)
        self.elements = temp.elements
    }
    public convenience init(roundedRect rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: UnsafePointer<CGAffineTransform>?) {
        self.init()
        let temp = CGMutablePath.init()
        temp.addRoundedRect(
            in: rect,
            cornerWidth: cornerWidth,
            cornerHeight: cornerHeight,
            transform: transform != nil ? transform!.pointee : .identity
        )
        self.elements = temp.elements
    }

    public var isEmpty: Bool {
        return elements.isEmpty
    }

    public func isRect(_ rect: UnsafeMutablePointer<CGRect>?) -> Bool {
        return false
    }

    public var currentPoint: CGPoint {
        return self._currentPoint ?? .zero
    }

    public var boundingBox: CGRect {
        return .zero
    }
    public var boundingBoxOfPath: CGRect {
        return .zero
    }
    public func contains(_ point: CGPoint, using rule: CGPathFillRule = .winding, transform: CGAffineTransform = .identity) -> Bool {
        return true
    }
    public func apply(info: UnsafeMutableRawPointer?, function: CGPathApplierFunction) {

    }
    public func applyWithBlock(_ block: (UnsafePointer<CGPathElement>) -> Void) {

    }
}
extension CGPath {
    public var _currentPoint: CGPoint? {
        if let e = elements.last {
            switch e {
            case let .move(to: p): return p
            case let .line(to: p): return p
            case let .quadCurve(to: p, control: _): return p
            case let .curve(to: p, control1: _, control2: _): return p
            case .closeSubpath: return nil
            }
        }
        return nil
    }
    public func forEach(_ body: (Element) -> Void) {
        elements.forEach(body)
    }
}
public enum CGPathElementType: Int32 {
    case moveToPoint = 0
    case addLineToPoint = 1
    case addQuadCurveToPoint = 2
    case addCurveToPoint = 3
    case closeSubpath = 4
}

public struct CGPathElement {
    public var type: CGPathElementType
    public var points: UnsafeMutablePointer<CGPoint>
}
public typealias CGPathApplierFunction = (UnsafeMutableRawPointer?, UnsafePointer<CGPathElement>) -> Void
public typealias CGPathApplyBlock = (UnsafePointer<CGPathElement>) -> Void

extension CGMutablePath {
    public func _addElement(_ e: Element){
        elements.append(e)
    }
    public func _addRoundedRect(
        in rect: CGRect,
        cornerSize: CGSize,
        style: RoundedCornerStyle = .circular,
        transform: CGAffineTransform = .identity
    ) {
        let roundSize = CGSize.init(width: min(cornerSize.width, rect.size.width * 0.5), height: min(cornerSize.height, rect.size.height * 0.5))

        let kappa: CGFloat = 0.552284749831  //(4.0/3.0)*(sqrt(2.0)-1.0)
        let ox = (roundSize.width) * kappa  // control point offset horizontal
        let oy = (roundSize.height) * kappa  // control point offset vertical

        let p1 = CGPoint.init(x: rect.minX + roundSize.width, y: rect.minY)
        let p2 = CGPoint.init(x: rect.minX, y: rect.minY + roundSize.height)
        self.move(to: p1)
        self.addCurve(to: p2, control1: .init(x: p1.x - ox, y: p1.y), control2: .init(x: p2.x, y: p2.y - oy))

        let p3 = CGPoint.init(x: rect.minX, y: rect.maxY - roundSize.height)
        let p4 = CGPoint.init(x: rect.minX + roundSize.width, y: rect.maxY)
        self.addLine(to: p3)
        self.addCurve(to: p4, control1: .init(x: p3.x, y: p3.y + oy), control2: .init(x: p4.x - ox, y: p4.y))

        let p5 = CGPoint.init(x: rect.maxX - roundSize.width, y: rect.maxY)
        let p6 = CGPoint.init(x: rect.maxX, y: rect.maxY - roundSize.height)
        self.addLine(to: p5)
        self.addCurve(to: p6, control1: .init(x: p5.x + ox, y: p5.y), control2: .init(x: p6.x, y: p6.y + oy))

        let p7 = CGPoint.init(x: rect.maxX, y: rect.minY + roundSize.height)
        let p8 = CGPoint.init(x: rect.maxX - roundSize.width, y: rect.minY)
        self.addLine(to: p7)
        self.addCurve(to: p8, control1: .init(x: p7.x, y: p7.y - oy), control2: .init(x: p8.x + ox, y: p8.y))
        self.addLine(to: p1)
        self.closeSubpath()
    }
    func _addArcLine(center: CGPoint, radius: CGFloat, startRadians: CGFloat, delta: CGFloat) {
        var startRadians = startRadians
        var deltaRadians = delta.truncatingRemainder(dividingBy: Double.pi * 2)

        let PI_2 = Double.pi * 0.5
        startRadians += PI_2

        if deltaRadians < 0 {
            startRadians += deltaRadians
            deltaRadians = abs(deltaRadians)
        }

        while deltaRadians > 0.0 {
            self._addArcLineLessPI_2(center: center, radius: radius, startRadians: startRadians, delta: min(PI_2, deltaRadians))
            deltaRadians -= PI_2
            startRadians += PI_2
        }
    }
    func _addArcLineLessPI_2(center: CGPoint, radius: CGFloat, startRadians: CGFloat, delta: CGFloat) {
        let start = CGPoint.init(x: radius * sin(startRadians), y: radius * cos(startRadians)).offset(point: center)

        let endRadians = startRadians + delta
        let end = CGPoint.init(x: radius * sin(endRadians), y: radius * cos(endRadians)).offset(point: center)
        self._addArcLine(center: center, start: start, end: end)
    }
    func _addArcLine(center: CGPoint, start: CGPoint, end: CGPoint) {
        let ax = start.x - center.x
        let ay = start.y - center.y
        let bx = end.x - center.x
        let by = end.y - center.y
        let q1 = (ax * ax) + (ay * ay)
        let q2 = q1 + (ax * bx) + (ay * by)
        let k2 = 4 / 3 * (sqrt(2 * q1 * q2) - q2) / ((ax * by) - (ay * bx))
        let control1 = CGPoint(x: center.x + ax - (k2 * ay), y: center.y + ay + (k2 * ax))
        let control2 = CGPoint(x: center.x + bx + (k2 * by), y: center.y + by - (k2 * bx))

        self.addCurve(to: end, control1: control1, control2: control2)
    }
}


public enum RoundedCornerStyle {
    case circular
    case continuous
}
extension RoundedCornerStyle : Hashable {
}