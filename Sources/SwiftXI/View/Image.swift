public struct Image : Equatable {
    let provider: AnyImageProviderBox
    init(_ box: AnyImageProviderBox){
        provider = box
    }
}

class _ImageViewContent{
    var image: NSImage
    var scale: CGFloat? = nil
    var resizingMode: Image.ResizingMode? = nil

    init(_ image: NSImage){
        self.image = image
    }
}
protocol _ImageViewContentProtocol{
    func _getRenderImage() -> _ImageViewContent
}
class AnyImageProviderBox: Equatable{
    static func == (lhs: AnyImageProviderBox, rhs: AnyImageProviderBox) -> Bool{
        return lhs.isEqual(to: rhs)
    }
    func isEqual(to object: AnyImageProviderBox) -> Bool{
        return type(of: self) == type(of: object)
    }
    func _getRenderImage() -> _ImageViewContent{
        fatalError()
    }
}

extension AnyImageProviderBox: _ImageViewContentProtocol{
}

class CGImageProvider: AnyImageProviderBox{
    let image: CGImage
    let scale: CGFloat
    let orientation: Image.Orientation
    let label: Text?
    let decorative: Bool
    init(_ cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation, label: Text? = nil, decorative: Bool = false){
        self.image = cgImage
        self.scale = scale
        self.orientation = orientation
        self.label = label
        self.decorative = decorative
    }
    override func isEqual(to object: AnyImageProviderBox) -> Bool{
        guard let rhs = object as? CGImageProvider else{
            return false
        }
        return self.image == rhs.image
                && self.scale == rhs.scale
                && self.orientation == rhs.orientation
                && self.label == rhs.label
                && self.decorative == rhs.decorative
    }
    override func _getRenderImage() -> _ImageViewContent{
        let content = _ImageViewContent.init(.init(cgImage: image))
        content.scale = self.scale
        return content
    }
}

class ImageProviderBox<T>: AnyImageProviderBox where T: Equatable, T: _ImageViewContentProtocol{
    let base: T
    init(_ base: T){
        self.base = base
    }
    override func isEqual(to object: AnyImageProviderBox) -> Bool{
        guard let rhs = object as? ImageProviderBox else{
            return false
        }
        return self.base == rhs.base
    }
    override func _getRenderImage() -> _ImageViewContent{
        return base._getRenderImage()
    }
}
extension Image {
    struct NamedImageProvider:  Equatable{
        let name: String
        let location: Location
        let label: ImageLabel?
        let decorative: Bool

        init(_ name: String, location: Location = .bundle(Bundle.main), label: ImageLabel? = nil, decorative: Bool = false){
            self.name = name
            self.location = location
            self.label = label
            self.decorative = decorative
        }
        enum Location: Equatable{
            case system
            case bundle(Bundle)
        }
        enum ImageLabel: Equatable{
            case text(Text)
            case systemSymbol(String)
        }
    }
    public init(_ name: String, bundle: Bundle? = nil){
        self.init(name, bundle: bundle, label: Text(LocalizedStringKey(name)))
    }
    public init(_ name: String, bundle: Bundle? = nil, label: Text){
        let lebel: NamedImageProvider.ImageLabel = .text(label)
        let location: NamedImageProvider.Location = .bundle(bundle ?? Bundle.main)
        let base = NamedImageProvider.init(name, location: location, label: lebel)
        self.init(ImageProviderBox.init(base))
    }
    public init(decorative name: String, bundle: Bundle? = nil){
        let location: NamedImageProvider.Location = .bundle(bundle ?? Bundle.main)
        let base = NamedImageProvider.init(name, location: location, decorative: true)
        self.init(ImageProviderBox.init(base))
    }
    public init(systemName: String){
        self.init(ImageProviderBox.init(NamedImageProvider.init(systemName, location: .system, label: .systemSymbol(systemName))))
    }
}

extension Image {
    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image{
        return self
    }
}

extension Image {
    public init(nsImage: NSImage){
        self.init(ImageProviderBox.init(nsImage))
    }
    public init(_ cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up, label: Text){
        self.init(CGImageProvider.init(cgImage, scale: scale, orientation: orientation, label: label))
    }
    public init(decorative cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up){
        self.init(CGImageProvider.init(cgImage, scale: scale, orientation: orientation, decorative: true))
    }
}

extension Image : View {
}
extension Image : _NeverPublicBody{
}

extension Image {
    public enum TemplateRenderingMode: Equatable, Hashable {
        case template
        case original
    }


    public enum Scale: Equatable, Hashable {
        case small
        case medium
        case large
    }
}

extension Image {
    public enum Interpolation: Equatable, Hashable{
        case none
        case low
        case medium
        case high
    }
}

extension Image {
    public func interpolation(_ interpolation: Image.Interpolation) -> Image{
        return self
    }
    public func antialiased(_ isAntialiased: Bool) -> Image{
        return self
    }
}

extension Image {
    public enum ResizingMode: Equatable, Hashable {
        case tile
        case stretch
    }
    struct ResizableProvider: Equatable{
        let provider: AnyImageProviderBox
        let capInsets: EdgeInsets
        let resizingMode: Image.ResizingMode
    }
    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image{
        let base = ResizableProvider.init(provider: self.provider, capInsets: capInsets, resizingMode: resizingMode)
        return .init(ImageProviderBox.init(base))
    }
}

extension Image {
    public enum Orientation : UInt8, CaseIterable, Hashable, RawRepresentable {
        case up
        case upMirrored
        case down
        case downMirrored
        case left
        case leftMirrored
        case right
        case rightMirrored
    }
}


extension Image.ResizableProvider: _ImageViewContentProtocol{
    func _getRenderImage() -> _ImageViewContent{
        let result = provider._getRenderImage()
        result.resizingMode = self.resizingMode
        return result
    }
}
extension Image.NamedImageProvider: _ImageViewContentProtocol{
    func _getRenderImage() -> _ImageViewContent{
        //no assets.car
        let image = NSImage.init(named: name) ?? NSImage.init()
        return .init(image)
    }
}

extension NSImage : _ImageViewContentProtocol{
    func _getRenderImage() -> _ImageViewContent{
        return .init(self)
    }
}
extension Image : _ImageViewContentProtocol{
    func _getRenderImage() -> _ImageViewContent{
        return provider._getRenderImage()
    }
}

extension View {
    public func imageScale(_ scale: Image.Scale) -> some View{
        return self
    }
}