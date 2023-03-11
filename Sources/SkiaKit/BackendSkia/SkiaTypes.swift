


extension String{
    func toSkString() -> ScString{
        var str = ScString()
        self.utf8CString.withUnsafeBufferPointer { ptr in
            let ptr = ptr.baseAddress!
            str = ScString(ptr);
        }
        return str
    }
}

extension ScString{
    func toString() -> String{
        var pointer: UnsafeMutablePointer<CChar>? = nil
        self.getData(&pointer)
        guard let pointer = pointer else{
            return ""
        }
        return String.init(cString: pointer)
    }
}

extension ScSize{
    func toCGSize() -> CGSize{
        return .init(width: CGFloat(self.width()), height: CGFloat(self.height()))
    }
}
extension CGSize{
    func toSkSize() -> ScSize{
        return .Make(SkScalar(self.width), SkScalar(self.height))
    }
}
extension CGPoint{
    func toSkPoint() ->ScPoint{
        return .Make(SkScalar(self.x), SkScalar(self.y));
    }
}

extension ScPoint{
    func toCGPoint() -> CGPoint{
        return .init(x: CGFloat(self.x()), y: CGFloat(self.y()))
    }
}

extension ScRect{
    func toCGRect() -> CGRect{
        return .init(x: CGFloat(x()), y: CGFloat(y()), width: CGFloat(width()), height: CGFloat(height()))
    }
}
extension CGRect{
    func toSkRect() -> ScRect{
        return .MakeXYWH(SkScalar(origin.x), SkScalar(origin.y), SkScalar(size.width), SkScalar(size.height))
    }
}

extension ScFontStyle.Weight{
     static func from(_ weight: NSFont.Weight) -> Self{
            switch weight{
                case .ultraLight: return .thin_Weight
                case .thin: return .extraLight_Weight
                case .light: return .light_Weight
                case .regular: return .normal_Weight
                case .medium: return .medium_Weight
                case .semibold: return .semiBold_Weight
                case .bold: return .bold_Weight
                case .heavy: return .extraBold_Weight
                case .black: return .black_Weight
                default:
                break
            }
            return .normal_Weight
        }
}
 