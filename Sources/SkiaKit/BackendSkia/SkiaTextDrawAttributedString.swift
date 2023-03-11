

class _AttributedStringDrawContextCache{
    typealias CacheItem = _SkiaTextGlyphItem
    var lines = [CacheLine].init()
    var size: CGSize = .zero
    var limitWidth: CGFloat = 10000

    class CacheLine{
        var items = [CacheItem].init()
        var sublines = [CacheSubLine].init()
        var pos = CGPoint.zero
        var size = CGSize.zero
        init(){}

        class CacheSubLine{
            var startItemIndex: Int = 0
            var startItemOffset = 0
            var count = 0

            var pos = CGPoint.zero
            var size = CGSize.zero
            var ascender: CGFloat = 0
        }
    }
    
    func layoutGlyphsPos(){
        var max_width: CGFloat = 0
        var max_height: CGFloat = 0
        lines.forEach{ line in
            var line_width: CGFloat = 0
            var line_height: CGFloat = 0

            line.layoutSublines(limitWidth)
            line.sublines.forEach{ subline in
                line_width = CGFloat.maximum(line_width, subline.size.width)
            }
            if let subline = line.sublines.last{
                line_height = (subline.pos.y + subline.size.height)
            }
            line.pos = .init(x: 0, y: max_height)
            line.size = .init(width: line_width, height: line_height)
            max_width = CGFloat.maximum(line_width, max_width)
            max_height += line_height
        }
        
        size = .init(width: max_width, height: max_height)
    }
}
extension _AttributedStringDrawContextCache.CacheLine{
    func drawForEach(drawBlock: (Range<Int>, NSFont, CGPoint, _AttributedStringDrawContextCache.CacheItem)->()){
        self.sublines.forEach{ subline in
            var count = subline.count
            var subPos = subline.pos + pos
            subPos = subPos.offset(y: subline.ascender)

            for itemIndex in subline.startItemIndex ..< items.count{
                let item = items[itemIndex]
                let itemStart = subline.startItemOffset
                let itemCount = min(item.glyphs.count - itemStart, count)

                count -= itemCount
                item.drawForEach( itemStart ..< (itemStart+itemCount) ){ (r, f) in
                    drawBlock(r, f, subPos, item)
                }
                if count == 0 {
                    break
                }
            }
        }
    }
    func layoutSublines(_ limitWidth: CGFloat){
        sublines.removeAll()
        var subline = CacheSubLine.init()
        sublines.append(subline)

        var pos_height: CGFloat = 0

        var line_width: CGFloat = 0
        var line_height: CGFloat = 0
        var line_ascender: CGFloat = 0

        items.enumerated().forEach { itemIt in
            let item = itemIt.element
            var itemFontUsedForSubline = false
            item.glyphs.enumerated().forEach{ it in
                let index = it.offset

                if ( line_width + CGFloat(item.widths[index]) > limitWidth ){
                    subline.size = CGSize.init(width: line_width, height: line_height)
                    subline.ascender = line_ascender
                    
                    subline = CacheSubLine.init()
                    sublines.append(subline)
                    pos_height += line_height

                    subline.pos = CGPoint.init(x: 0, y: pos_height)
                    subline.startItemIndex = itemIt.offset
                    subline.startItemOffset = index

                    line_width = 0
                    itemFontUsedForSubline = false
                }
                
                item.positions[index].fX = SkScalar(line_width)
                line_width += CGFloat(item.widths[index])
                subline.count += 1

                if (!itemFontUsedForSubline && line_height < item.lineHeight){
                    itemFontUsedForSubline = true
                    line_height = item.lineHeight
                    line_ascender = item.ascender
                }
            }
        }
        subline.size = CGSize.init(width: line_width, height: line_height)
        subline.ascender = line_ascender
    }
}
extension _AttributedStringDrawContext{
    func draw() {
        let context = NSGraphicsContext.current?.cgContext
        guard let context = context else{
            return
        }
        self.draw(context)
    }
    func draw(_ context: CGContext) {
        cache.lines.forEach{ line in
            line.drawForEach{(r, font, pos, item) in
                let glyphs = Array(item.glyphs[r])
                let positions = Array(item.positions[r])
                context.drawGlyphs(glyphs.count, glyphs: glyphs, positions: positions ,origin: pos.toSkPoint(), font:font)
            }
        }
    }
    public var size: CGSize {
        doLayout()
        return cache.size
    }
    public func layoutWith(width: CGFloat = CGFloat.greatestFiniteMagnitude){
        cache.limitWidth = width
        if cache.lines.count == 0 {
            doCacheGlyphItem()
        }
        cache.layoutGlyphsPos()
    }
    private func doCacheGlyphItem(){
        cache.lines.append(.init())
        let range = NSRange.init(location: 0, length: self.string.length)
        let string = self.string.string
        self.string.enumerateAttributes(in: range) { (attrs, r, _) in
            var font: NSFont? = nil
            if let f1 = attrs[.font] {
                font = f1 as? NSFont
            }
            if font == nil {
                font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
            }
            let itemString = String(string[Range<String.Index>.init(r, in: string)!])

            var firstLine = true
            itemString.components(separatedBy: .newlines).forEach{
                if (!firstLine){
                    cache.lines.append(.init())
                }
                let item = _AttributedStringDrawContextCache.CacheItem.init($0, font: font!)
                item.layoutGlyphs()
                cache.lines.last?.items.append(item)

                firstLine = false
            }
        }
    }
    public func doLayout(){
        if cache.lines.count > 0 {
            return
        }
        doCacheGlyphItem()
        cache.layoutGlyphsPos()
    }
}

public class _AttributedStringDrawContext{
    let string: NSAttributedString
    let cache = _AttributedStringDrawContextCache.init()
    public init(_ string: NSAttributedString){
        self.string = string
        print("---- text ComputableLayout \(self.string)")
    }
    public func drawText(){
        self.draw()
    }
}

public typealias _TextViewDrawContext = _AttributedStringDrawContext