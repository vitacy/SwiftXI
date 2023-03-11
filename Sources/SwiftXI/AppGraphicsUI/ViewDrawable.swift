protocol ViewDrawable {
    func draw(node: _ViewElementNode)
    func config(node: _ViewElementNode)
    func finish(node: _ViewElementNode)

    func drawRect(_ rect: CGRect, node: _ViewElementNode)
    func drawRect(_ ret: CGRect)
}

protocol ViewModifierDrawable: _ViewElementNodeCreator, ViewDrawable{
}
extension ViewDrawable {
    func draw(node: _ViewElementNode) {
        let ctx = NSGraphicsContext.current
        ctx?.saveGraphicsState()
        node.transform.concat()
        var bounds = node.geometry.bounds
        if let layer = node.layer{
            bounds.size = layer.size
        }
        drawRect(bounds, node: node)
        ctx?.restoreGraphicsState()
    }

    func config(node: _ViewElementNode) {
    }
    func drawRect(_ rect: CGRect) {
    }
    func drawRect(_ rect: CGRect, node: _ViewElementNode) {
        drawRect(rect)
    }
    func finish(node: _ViewElementNode){

    }
}
extension _ViewElementNode{
    var transform: CGAffineTransform{
        let value = self
        let layout = value.geometry
        var position = layout.absolutePosition

        if let layer = value.layer{
            position = layer.position
        }
        //avoid text offset by 0.5 point
        position.x = position.x.rounded()
        position.y = position.y.rounded()

        return CGAffineTransform.init(translationX: position.x, y: position.y)
    }
}
struct _ViewModifierContextDrawer{
    let node: _ViewElementNode
    let index: Int
    init(_ node: _ViewElementNode, index: Int = 0){
        self.node = node
        self.index = index
    }
    func drawViewContext(){
        if index >= node.modifiers.count{
            node.drawViewContext()
            return
        }
        let modifier = node.modifiers[index]
        let drawer = modifier.node.any as? ViewDrawable 
        drawer?.config(node: node)

        drawer?.draw(node: node)
        if modifier.isStackRoot{
            modifier.drawSubviewContext(zIndex: modifier.zIndex){
                _ViewModifierContextDrawer(node, index: index+1).drawViewContext()
            }
        }else{
            _ViewModifierContextDrawer(node, index: index+1).drawViewContext()
        }
        drawer?.finish(node: node)
    }
}
extension _ViewElementNode {
    func drawSubviewContext(zIndex: Double, drawer: ()->()){
        var done = false
        if let stack = self as? _StackViewElementNode{
            stack.children.sorted{ return $0.zIndex > $1.zIndex }
            .forEach{ child in
                if !done && child.zIndex >= zIndex{
                    drawer()
                    done = true
                }
                child.drawModifieredViewContext()
            }
        }
        if !done{
            drawer()
        }
    }
    func drawSubviewContext(){
        let stack = self as? _StackViewElementNode
        stack?.children.forEach { child in
            child.drawModifieredViewContext()
        }
    }
    func drawViewContext(){
        let drawer = self.node.any as? ViewDrawable 
        drawer?.config(node: self)

        if self.isStackRoot{
            drawSubviewContext()
        }else{
            drawer?.draw(node: self)
        }
        
        drawer?.finish(node: self)
    }
    func drawModifieredViewContext(){
        if modifiers.count > 0{
            let drawer = _ViewModifierContextDrawer(self)
            drawer.drawViewContext()
        }else{
            self.drawViewContext()
        }
    }
    func drawContext() {
        self.drawModifieredViewContext()
    }
}

extension Path {
    func drawToContext() {
        if case let .stroked(p) = self.storage {
            p.stroke()
        } else {
            self.fill()
        }
    }
}

extension Text: ViewDrawable {
    func drawRect(_ rect: CGRect, node: _ViewElementNode) {
        if let textCtx = node.node.traits._textViewData{
            ForegroundStyle().drawShapeStyle(rect, node: node)
            textCtx.text.drawText()
        }
    }
}
extension _ShapeView: ViewDrawable {
    func drawRect(_ rect: CGRect, node: _ViewElementNode) {
        let path = shape.path(in: rect)
        style.drawPathInRect(rect, path: path, node: node)
    }
}

extension Image: ViewDrawable {
    func drawRect(_ rect: CGRect, node: _ViewElementNode) {
        if let content = node.node.traits._imageViewData{
            content.image.draw(in: rect)
        }
    }
}



