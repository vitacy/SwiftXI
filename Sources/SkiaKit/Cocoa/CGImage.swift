
public class CGImage: Equatable{
    var _image: _CGImageInternal
    public static func == (lhs: CGImage, rhs: CGImage) -> Bool{
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public init?(width: Int, height: Int, bitsPerComponent: Int, bitsPerPixel: Int, bytesPerRow: Int, space: CGColorSpace, bitmapInfo: CGBitmapInfo, provider: CGDataProvider, decode: UnsafePointer<CGFloat>?, shouldInterpolate: Bool, intent: CGColorRenderingIntent){
        let bitmap = _CGImageInternal.init(width: width, height: height, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo, provider: provider)

        guard let bitmap = bitmap else {
            return nil
        }
        _image = bitmap
    }

    public var size: CGSize {
        return _image.size
    }
}
public typealias UIImage = NSImage
public class NSImage : NSObject {
    var reps: [NSImageRep]
    public override init(){
         self.reps = []
    }
    public init(_ rep: NSImageRep){
        self.reps = [rep]
    }
    enum Storage{
        case image(_SkiaImageRep)
        case cgImage(CGImage)
    }
    public convenience init?(named name: NSImage.Name){
        guard let path = Bundle.main.pathForImageResource(name) else{
            return nil
        }
        self.init(contentsOfFile: path)
    }
    public convenience init(cgImage: CGImage){
        self.init(cgImage)
    }
    public convenience init?(data: Data) {
        let image = _SkiaImageRep.init(data)
        guard let image = image else {
            return nil
        }
        self.init(image)
    }
    public convenience init?(contentsOfFile path: String){
        let data = NSData.init(contentsOfFile: path)
        if let data = data {
            self.init(data: data as Data)
        }else{
            return nil
        }
    }
    public var size: CGSize { 
        if let rep = self.reps.last{
            return rep.size 
        }
        return .zero
    }
    public var cgImage: CGImage? { 
        if let rep = self.reps.last{
            return rep as? CGImage
        }
        return nil
     }
     open var representations: [NSImageRep] {
        return reps
     }
     public var images: [UIImage]? {
        guard reps.count > 1 else{
            return nil
        }
        return reps.map{ UIImage.init($0)}
     }
}

public struct CGBitmapInfo : OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
public class CGDataProvider {
    let data: NSData
    public init(_ data: NSData){
        self.data = data
    }
}
extension CGDataProvider {
    public convenience init?(data: NSData){
        self.init(data)
    }
}

extension NSImage{
    public typealias Name = String
}

public protocol NSImageRep {
    var size: CGSize {get}
}

extension CGImage : NSImageRep{
}
extension Bundle {
    func image(forResource name: NSImage.Name) -> NSImage?{
        return NSImage.init(named: name)
    }
    func pathForImageResource(_ name: NSImage.Name) -> String?{
        return path(forResource: name, ofType: "png")
    }
    func urlForImageResource(_ name: NSImage.Name) -> URL?{
        guard let path = pathForImageResource(name) else{
            return nil
        }
        return URL.init(fileURLWithPath: path)
    }
}