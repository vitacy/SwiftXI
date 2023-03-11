extension CGFloat {
    static func fixValue(_ value: inout CGFloat, min: CGFloat, max: CGFloat) {
        if value < min {
            value = min
        }
        if value > max {
            value = max
        }
    }
    func fixValueIn(min: CGFloat, max: CGFloat) -> CGFloat {
        var value = self
        Self.fixValue(&value, min: min, max: max)
        return value
    }

    func isAboutEqual(_ to: CGFloat) -> Bool{
        return (self - to).abs() < 0.0001
    }
}

extension Double{
    func abs() -> Double{
        return Swift.abs(self)
    }
}
