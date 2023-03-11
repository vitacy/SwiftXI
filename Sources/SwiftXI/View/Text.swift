class AnyTextStorage: Equatable {
    static func == (lhs: AnyTextStorage, rhs: AnyTextStorage) -> Bool{
        return lhs.isEqual(to: rhs)
    }
    func isEqual(to object: AnyTextStorage) -> Bool{
        return type(of: self) == type(of: object)
    }
    var attributedStringValue: NSAttributedString{
        return .init(string: "")
    }
}
class AnyTextModifier: Equatable {
    static func == (lhs: AnyTextModifier, rhs: AnyTextModifier) -> Bool{
        return lhs.isEqual(to: rhs)
    }
    func isEqual(to object: AnyTextModifier) -> Bool{
        return type(of: self) == type(of: object)
    }
}
struct LineStyle: Equatable{
    let active: Bool
    let color: Color?
}
public struct Text : Equatable {
    var storage: Storage
    var modifiers: Array<Modifier>

    enum Storage: Equatable {
        case verbatim(String)
        case anyTextStorage(AnyTextStorage)
    }
    enum Modifier: Equatable {
        case color(Color?)
        case font(Font?)
        case italic
        case weight(Font.Weight?)
        case kerning(CGFloat)
        case tracking(CGFloat)
        case baseline(CGFloat)
        case anyTextModifier(AnyTextModifier)
    }
    init(_ storage: Storage, modifiers: Array<Modifier> = .init()){
        self.storage = storage
        self.modifiers = modifiers
    }
    public init(verbatim content: String){
        self.init(.verbatim(content))
    }
    public init<S>(_ content: S) where S : StringProtocol{
        self.init(.verbatim(String(content)))
    }
}

extension Text {
    class BoldTextModifier: AnyTextModifier{
    }
    class UnderlineTextModifier: AnyTextModifier{
        let lineStyle: LineStyle
        init(_ lineStyle: LineStyle){
            self.lineStyle = lineStyle
        }
        override func isEqual(to object: AnyTextModifier) -> Bool{
            guard let rhs = object as? UnderlineTextModifier else{
                return false
            }
            return self.lineStyle == rhs.lineStyle
        }
    }
    class StrikethroughTextModifier: AnyTextModifier{
        let lineStyle: LineStyle
        init(_ lineStyle: LineStyle){
            self.lineStyle = lineStyle
        }
        override func isEqual(to object: AnyTextModifier) -> Bool{
            guard let rhs = object as? StrikethroughTextModifier else{
                return false
            }
            return self.lineStyle == rhs.lineStyle
        }
    }
    func modifier(_ m: Modifier) -> Text{
        let arr = modifiers + [m]
        return .init(self.storage, modifiers: arr)
    }
    public func foregroundColor(_ color: Color?) -> Text{
        return modifier(.color(color))
    }
    public func font(_ font: Font?) -> Text{
        return modifier(.font(font))
    }
    public func fontWeight(_ weight: Font.Weight?) -> Text{
        return modifier(.weight(weight))
    }
    public func bold() -> Text{
        return modifier(.anyTextModifier(BoldTextModifier.init()))
    }
    public func italic() -> Text{
        return modifier(.italic)
    }
    public func strikethrough(_ active: Bool = true, color: Color? = nil) -> Text{
        let lineStyle = LineStyle.init(active: active, color: color)
        return modifier(.anyTextModifier(StrikethroughTextModifier.init(lineStyle)))
    }
    public func underline(_ active: Bool = true, color: Color? = nil) -> Text{
        let lineStyle = LineStyle.init(active: active, color: color)
        return modifier(.anyTextModifier(UnderlineTextModifier.init(lineStyle)))
    }
    public func kerning(_ kerning: CGFloat) -> Text{
        return modifier(.kerning(kerning))
    }
    public func tracking(_ tracking: CGFloat) -> Text{
        return modifier(.tracking(tracking))
    }
    public func baselineOffset(_ baselineOffset: CGFloat) -> Text{
        return modifier(.baseline(baselineOffset))
    }
}

extension Text {
    class AttachmentTextStorage: AnyTextStorage{
        let image: Image
        init(_ image: Image){
            self.image = image
        }
        override func isEqual(to object: AnyTextStorage) -> Bool{
            guard let rhs = object as? AttachmentTextStorage else{
                return false
            }
            return self.image == rhs.image
        }
    }
    public init(_ image: Image){
        self.init(.anyTextStorage(AttachmentTextStorage.init(image)))
    }
}
extension Text {
    public struct DateStyle: Equatable {
        let storage: Storage
        public static let time: Text.DateStyle = .init(storage: .time)
        public static let date: Text.DateStyle = .init(storage: .date)
        public static let relative: Text.DateStyle = .init(storage: .relative)
        public static let offset: Text.DateStyle = .init(storage: .offset)
        public static let timer: Text.DateStyle = .init(storage: .timer)
        
        enum Storage: Equatable {
            case time
            case date
            case relative
            case offset
            case timer
        }
    }
    class DateTextStorage: AnyTextStorage{
        let storage: Storage
        enum Storage: Equatable {
            case interval(DateInterval)
            case absolute(Date, DateStyle)
        }
        init(_ storage: Storage){
            self.storage = storage
        }
        override func isEqual(to object: AnyTextStorage) -> Bool{
            guard let rhs = object as? DateTextStorage else{
                return false
            }
            return self.storage == rhs.storage
        }
    }
    public init(_ date: Date, style: Text.DateStyle){
        let storage = DateTextStorage.init(.absolute(date, style))
        self.init(.anyTextStorage(storage))
    }
    public init(_ dates: ClosedRange<Date>){
        let interval = DateInterval.init(start: dates.lowerBound, end: dates.upperBound)
        self.init(interval)
    }
    public init(_ interval: DateInterval){
        let storage = DateTextStorage.init(.interval(interval))
        self.init(.anyTextStorage(storage))
    }
}

extension Text {
    class FormatterTextStorage<T>: AnyTextStorage where T: Equatable{
        let object: T
        let formatter: Formatter
        init(_ object: T, formatter: Formatter){
            self.object = object
            self.formatter = formatter
        }
        override func isEqual(to object: AnyTextStorage) -> Bool{
            guard let rhs = object as? FormatterTextStorage else{
                return false
            }
            return self.object == rhs.object && self.formatter == rhs.formatter
        }
    }
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : ReferenceConvertible{
        let storage = FormatterTextStorage.init(subject, formatter: formatter)
        self.init(.anyTextStorage(storage))
    }
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : NSObject{
        let storage = FormatterTextStorage.init(subject, formatter: formatter)
        self.init(.anyTextStorage(storage))
    }
}

extension Text {
    class LocalizedTextStorage: AnyTextStorage{
        let key: LocalizedStringKey
        let tableName: String?
        let bundle: Bundle?
        init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil){
            self.key = key
            self.tableName = tableName
            self.bundle = bundle
        }
        override var attributedStringValue: NSAttributedString{
            let str: String = NSLocalizedString(key.key, tableName: tableName, bundle: bundle ?? Bundle.main, comment:"")
            return .init(string: str)
        }
        override func isEqual(to object: AnyTextStorage) -> Bool{
            guard let rhs = object as? LocalizedTextStorage else{
                return false
            }
            return self.key == rhs.key
        }
    }
    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil){
        let storage = LocalizedTextStorage.init(key, tableName: tableName, bundle: bundle)
        self.init(.anyTextStorage(storage))
    }
}

extension Text {
    class ConcatenatedTextStorage: AnyTextStorage{
        let first: Text
        let second: Text
        init(first: Text, second: Text){
            self.first = first
            self.second = second
        }
        override var attributedStringValue: NSAttributedString{
            let str = NSMutableAttributedString.init(attributedString: first.attributedStringValue)
            str.append(second.attributedStringValue)
            return str
        }
        override func isEqual(to object: AnyTextStorage) -> Bool{
            guard let rhs = object as? ConcatenatedTextStorage else{
                return false
            }
            return self.first == rhs.first && self.second == self.second
        }
    }
    public static func + (lhs: Text, rhs: Text) -> Text{
        let storage = ConcatenatedTextStorage.init(first: lhs, second: rhs)
        return .init(.anyTextStorage(storage))
    }
}


extension Text {
    public enum TruncationMode: Equatable, Hashable {
        case head
        case tail
        case middle
    }

    public enum Case: Equatable, Hashable{
        case uppercase
        case lowercase
    }
}

extension Text : View{
}
extension Text : _NeverPublicBody{
}

extension Text{
    var attributedStringValue: NSAttributedString{
        let result: NSMutableAttributedString = .init(string: "")
        switch storage{
            case let .verbatim(str): result.append(.init(string: str))
            case let .anyTextStorage(text): result.append(text.attributedStringValue)
        }
        let r = NSRange.init(location: 0, length: result.length)
        for m in modifiers{
            switch m{
                case let .color(c):  
                    if let c = c{
                        result.addAttribute(.foregroundColor, value: c, range: r)
                    }
                case let .font(font):  
                if let font = font{
                        result.addAttribute(.font, value: font, range: r)
                    }
                default: break
            }
        }
        return result
    }
}