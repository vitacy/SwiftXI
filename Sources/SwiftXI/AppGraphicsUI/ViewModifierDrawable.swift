extension _OpacityEffect: ViewModifierDrawable{
    func config(node: _ViewElementNode) { 
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.cgContext.setAlpha(opacity)
        // print("color opacity \(opacity)")
    }
    func finish(node: _ViewElementNode){
        NSGraphicsContext.restoreGraphicsState()
    }
}
extension _ClipEffect: ViewModifierDrawable{
    func config(node: _ViewElementNode) {
        NSGraphicsContext.saveGraphicsState()

        let bounds = node.geometry.frameInWindow
        let path = Path(bounds)
        path.addClip()
    }
    func finish(node: _ViewElementNode){
        NSGraphicsContext.restoreGraphicsState()
    }
}

extension _AspectRatioLayout: ViewModifierDrawable{
    func config(node: _ViewElementNode) {
        NSGraphicsContext.saveGraphicsState()
        if let aspectRatio = aspectRatio{
            let scaleX: CGFloat = aspectRatio >= 1 ? aspectRatio : 1.0
            let scaleY: CGFloat = aspectRatio >= 1 ? 1.0 : 1.0/aspectRatio

            let geometry = node.geometry
            let center = geometry.frameInWindow.centerPoint
            var ctm = CGAffineTransform.init()
            ctm=ctm.translatedBy(x: -center.x, y: -center.y)
            ctm=ctm.scaledBy(x: scaleX, y: scaleY)
            ctm=ctm.translatedBy(x: center.x, y: center.y)
            ctm.concat()
        }
    }
    func finish(node: _ViewElementNode){
        NSGraphicsContext.restoreGraphicsState()
    }
}