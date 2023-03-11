protocol _ShapeStyleDrawer {
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode)
}
extension ShapeStyle {
    func drawPathInRect(_ rect: CGRect, path: Path, node: _ViewElementNode) {
        let shapeStyle = self.in(rect)
        (shapeStyle as? _AnchoredShapeStyleDrawer)?.drawPath(path, node: node)
    }
}
extension _ShapeStyleDrawer {
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode){
        print("ShapeStyle setDrawStyle")
    }
}
protocol _AnchoredShapeStyleDrawer {
    func drawPath(_ path: Path, node: _ViewElementNode)
}

extension Color: _ShapeStyleDrawer {
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode) {
        self.set()
    }
}
extension ForegroundStyle: _ShapeStyleDrawer {
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode) {
        let v = node.node.environments[keyPath: \._foregroundColor] ?? Color.primary
        v.set()
    }
}
extension BackgroundStyle: _ShapeStyleDrawer {
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode) {
        Color.white.set()
    }
}

extension _AnchoredShapeStyle: _AnchoredShapeStyleDrawer{
}
extension _AnchoredShapeStyle: _ShapeStyleDrawer {
    func drawPath(_ path: Path, node: _ViewElementNode){
        drawShapeStyle(bounds, node: node)
        path.drawToContext()
    }
    func drawShapeStyle(_ rect: CGRect, node: _ViewElementNode){
        (style as? _ShapeStyleDrawer)?.drawShapeStyle(rect, node: node)
    }
}
