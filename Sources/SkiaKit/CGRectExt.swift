extension CGRect{
    init(center: CGPoint, size: CGSize){
        self.init()
        self.size = size
        self.origin = center.offset(size: CGSize.init(width: -size.width*0.5, height: -size.height*0.5))
    }
    var centerPoint: CGPoint{
        return .init(x: self.midX, y: self.midY)
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
    func middle(between to: CGPoint) -> CGPoint {
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
}