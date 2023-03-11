extension Color {
    func set() {
        NSColor.init(self).set()
    }
}
extension Path {
    func stroke() {
        let ctx = NSGraphicsContext.current?.cgContext
        if case let .stroked(p) = self.storage {
            p.stroke()
        } else {
            ctx?.strokePath(convertible: self)
        }
    }
    func fill() {
        let ctx = NSGraphicsContext.current?.cgContext
        ctx?.fillPath(convertible: self)
    }
}
extension Path: _PathConvertible{
}
extension Path.StrokedPath {
    func stroke() {
        let ctx = NSGraphicsContext.current?.cgContext
        ctx?.strokePath(convertible: self.path, style: self.style)
    }
}