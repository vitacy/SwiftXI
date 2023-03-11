
extension Color._Resolved {
    func toNSColor() -> NSColor {
        return .init(srgbRed: linearRed.sRGBFromLinear, green: linearGreen.sRGBFromLinear, blue: linearBlue.sRGBFromLinear, alpha: opacity)
    }
}

extension Path{
    func addClip(){
        NSGraphicsContext.current?.cgContext.clipPath(convertible: self)
    }
}