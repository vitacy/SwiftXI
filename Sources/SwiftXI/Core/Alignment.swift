import Foundation

public struct Alignment : Equatable{
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment
    
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public static var center: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.center)
    }
    
    public static var leading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.center)
    }
    
    public static var trailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.center)
    }
    
    public static var top: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.top)
    }
    
    public static var bottom: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.bottom)
    }
    
    public static var topLeading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.top)
    }
    
    public static var topTrailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.top)
    }
    
    public static var bottomLeading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.bottom)
    }
    
    public static var bottomTrailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.bottom)
    }
}

public protocol AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

public struct HorizontalAlignment : Equatable {
    var _id: AlignmentID.Type
    public init(_ id: AlignmentID.Type){
        _id = id
    }
    public static func == (a: HorizontalAlignment, b: HorizontalAlignment) -> Bool{
        return a._id == b._id
    }
}
extension HorizontalAlignment {
    private enum Leading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return 0
        }
    }
    private enum Center: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.width/2
        }
    }
    private enum Trailing: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.width
        }
    }
    public static let leading = HorizontalAlignment(Leading.self)
    public static let center = HorizontalAlignment(Center.self)
    public static let trailing = HorizontalAlignment(Trailing.self)
}

public struct VerticalAlignment : Equatable {
    var _id: AlignmentID.Type
    public init(_ id: AlignmentID.Type){
        _id = id
    }
    public static func == (a: VerticalAlignment, b: VerticalAlignment) -> Bool{
        return a._id == b._id
    }
}
extension VerticalAlignment {
    private enum Top: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return 0
        }
    }
    private enum Center: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.height/2
        }
    }
    private enum Bottom: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.height
        }
    }
    private enum FirstTextBaseline: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.height
        }
    }
    private enum LastTextBaseline: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.height
        }
    }

    public static let top = VerticalAlignment(Top.self)
    public static let center = VerticalAlignment(Center.self)
    public static let bottom = VerticalAlignment(Bottom.self)
    public static let firstTextBaseline = VerticalAlignment(FirstTextBaseline.self)
    public static let lastTextBaseline = VerticalAlignment(LastTextBaseline.self)
}