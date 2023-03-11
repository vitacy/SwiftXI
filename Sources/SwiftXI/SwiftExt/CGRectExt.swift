extension CGRect{
    init(center: CGPoint, size: CGSize){
        self.init()
        self.size = size
        self.origin = center.offset(size: CGSize.init(width: -size.width*0.5, height: -size.height*0.5))
    }
    var centerPoint: CGPoint{
        get{
            return .init(x: self.midX, y: self.midY)
        }
        set{
            self.origin += newValue - self.centerPoint
        }
    }
    func anchorPoint(anchor: UnitPoint) -> CGPoint{
        return .init(x: origin.x + size.width*anchor.x, y: origin.y + size.height*anchor.y)
    }
    func scale(fit aspectRatio: CGFloat) -> CGRect{
        var rect = self

        let center = rect.centerPoint
        if (aspectRatio * rect.size.height < rect.size.width){
            rect.size.width = rect.size.height*aspectRatio
        }else if(aspectRatio > 0.01){
            rect.size.height = rect.size.width/aspectRatio
        }

        rect.centerPoint = center
        return rect
    }
    func scale(fill aspectRatio: CGFloat) -> CGRect{
        var rect = self
        
        let center = rect.centerPoint
        if (aspectRatio * rect.size.height < rect.size.width){
            rect.size.height = rect.size.width/aspectRatio
        }else{
            rect.size.width = rect.size.height*aspectRatio
        }

        rect.centerPoint = center
        return rect
    }
}

extension CGPoint {
    func distence(to: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - to.x, 2) + pow(self.y - to.y, 2))
    }
    func move(percent: CGFloat, to: CGPoint) -> CGPoint {
        return CGPoint.init(x: self.x + (to.x - self.x) * percent, y: self.y + (to.y - self.y) * percent)
    }
    func move(distence: CGFloat, to: CGPoint) -> CGPoint {
        let d = self.distence(to: to)
        return self.move(percent: distence / d, to: to)
    }
    func offset(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint{
        return .init(x: self.x + x, y: self.y + y)
    }
    func offset(point: CGPoint) -> CGPoint{
        return self.offset(x: point.x, y: point.y)
    }
    func offset(size: CGSize) -> CGPoint{
        return self.offset(x: size.width, y: size.height)
    }
    func middle(to: CGPoint) -> CGPoint {
        return CGPoint.init(x: (to.x + self.x) * 0.5, y: (to.y + self.y) * 0.5)
    }
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return lhs.offset(x: rhs.x, y: rhs.y)
    }
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return lhs.offset(x: -rhs.x, y: -rhs.y)
    }
    static func += (lhs: inout CGPoint, rhs: CGPoint){
        lhs = lhs + rhs
    }
}

extension CGSize{
    func offset(width: CGFloat = 0, height: CGFloat = 0) -> CGSize{
        return .init(width: self.width + width, height: self.height + height)
    }
    func offset(point: CGPoint) -> CGSize{
        return self.offset(width: point.x, height: point.y)
    }
    func offset(size: CGSize) -> CGSize{
        return self.offset(width: size.width, height: size.height)
    }
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize{
        return lhs.offset(width: rhs.width, height: rhs.height)
    }
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize{
        return lhs.offset(width: -rhs.width, height: -rhs.height)
    }
    static func -= (lhs: inout CGSize, rhs: CGSize){
        lhs = lhs - rhs
    }
    static func += (lhs: inout CGSize, rhs: CGSize){
        lhs = lhs + rhs
    }

    func replacing(minSize: CGSize) -> CGSize{
        var result = self
        if result.width < minSize.width{
            result.width = minSize.width
        }
        if result.height < minSize.height{
            result.height = minSize.height
        }
        return result
    }
    func replacing(maxSize: CGSize) -> CGSize{
        return replacing(maxSize){$0 > $1}
    }
    func replacing(_ size: CGSize, isReplacing: (CGFloat, CGFloat)->Bool) -> CGSize{
        var result = self
        if isReplacing(result.width, size.width){
            result.width = size.width
        }
        if isReplacing(result.height, size.height){
            result.height = size.height
        }
        return result
    }
}