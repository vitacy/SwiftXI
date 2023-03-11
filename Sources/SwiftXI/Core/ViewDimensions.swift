import Foundation

public struct ViewDimensions {
    var size: CGSize

    init(size: CGSize){
        self.size = size
    }
    public var width: CGFloat {
        return size.width
    }
    public var height: CGFloat {
        return size.height
    }
    public subscript(guide: HorizontalAlignment) -> CGFloat {
        return guide._id.defaultValue(in: self)
    }
    public subscript(guide: VerticalAlignment) -> CGFloat {
        return guide._id.defaultValue(in: self)
    }
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? {
        return nil
    }
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? {
        return nil
    }
}

extension ViewDimensions: Equatable {
    public static func == (a: ViewDimensions, b: ViewDimensions) -> Bool {
        return a.size == b.size
    }
}