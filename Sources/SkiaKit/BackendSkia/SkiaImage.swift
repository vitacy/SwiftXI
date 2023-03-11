
extension ScBitmap{
    init?(width: Int, height: Int, bytesPerRow: Int, space: CGColorSpace, bitmapInfo: CGBitmapInfo, provider: CGDataProvider){
        self.init()

        let info = ScImageInfo.Make(Int32(width), Int32(height), .rgba_8888_SkColorType, .unpremul_SkAlphaType)
        let p = CXXSwiftInterop.shared.cxx_pointer_from_swift_object(provider)
        CXXSwiftInterop.shared.retain(p, CGDataProvider.self)
        let pixels = UnsafeMutableRawPointer.init(mutating: provider.data.bytes)

        func releaseContext(addr: UnsafeMutableRawPointer?, context: UnsafeMutableRawPointer?){
            if let context = context{
                CXXSwiftInterop.shared.release(context, CGDataProvider.self)
            }
        }
        
        self.installPixels(info, pixels, bytesPerRow, releaseContext, p)
        self.setImmutable()
    }
    var size: CGSize {
        return .init(width: CGFloat(self.width()), height: CGFloat(self.height()))
    }
}

extension ScData{
    init(_ data: NSData){
        let p = CXXSwiftInterop.shared.cxx_pointer_from_swift_object(data)
        CXXSwiftInterop.shared.retain(p, NSData.self)

        func releaseData(addr: UnsafeRawPointer?, context: UnsafeMutableRawPointer?){
            if let context = context{
                CXXSwiftInterop.shared.release(context, NSData.self)
            }
        }

        let ptr = UnsafeMutableRawPointer.init(mutating: data.bytes)
        self.init(ptr, data.length, releaseData, p)
    }
}
extension ScImage{
    init?(_ data: Data){
        self.init(ScData.init(data as NSData))
        guard self.isValid() else{
            return nil
        }
    }
    public var size: CGSize {
        return .init(width: CGFloat(self.width()), height: CGFloat(self.height()))
    }
}
typealias _CGImageInternal = ScBitmap
typealias _SkiaImageRep = ScImage

extension _SkiaImageRep : NSImageRep{
}


