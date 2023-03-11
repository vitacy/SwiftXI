
    class _SkiaTextGlyphItem{
        var string = ""
        var unichars = [SkUnichar].init()
        var glyphs = [SkGlyphID].init()
        var widths = [SkScalar].init()
        var positions = [ScPoint].init()
        var indexOfFont = [Int].init()
        var fonts = [NSFont].init()

        func drawForEach(drawBlock: (Range<Int>, NSFont)->()){
            drawForEach(0 ..<  glyphs.count ,drawBlock:drawBlock)
        }
        func drawForEach(_ range: Range<Int>, drawBlock: (Range<Int>, NSFont)->()){
            guard range.count > 0 else{
                return
            }
            var startIndex = range.first!
            var fontIndex = indexOfFont[startIndex]
            for index in range{
                let curFontIndex = indexOfFont[index]
                if (curFontIndex != fontIndex){
                    drawBlock(startIndex ..< index, fonts[fontIndex])
                    fontIndex = curFontIndex
                    startIndex = index
                }
            }

            if startIndex < range.upperBound{
                drawBlock(startIndex ..< range.upperBound, fonts[fontIndex])
            }
        }
        
        var segments = Array<Range<Int>>.init()
        init(_ string: String, font: NSFont){
            self.string = string
            self.unichars = string.unicodeScalars.map{SkUnichar($0.value)}
            self.fonts.append(font)
        }

        var lineHeight: CGFloat{
            return self.fonts[0].lineHeight
        }
        var ascender: CGFloat {
            return self.fonts[0].ascender
        }
        

    func layoutGlyphs(){
        layoutGlyphsDefault()
        layoutGlyphsFallback()
    }
    func layoutGlyphsFallbackChar(_ char: SkUnichar, font: NSFont? = nil) -> (width: SkScalar, glyph: SkGlyphID, font: NSFont?){
        var width: SkScalar = 0
        var glyph: SkGlyphID = 0
        var fallback: NSFont? = nil

        if let font = font{
            font.layoutUnichar(char, glyph: &glyph, width: &width)
        }
        if fonts.count > 1 && glyph == 0{
            let font = fonts.last!
            font.layoutUnichar(char, glyph: &glyph, width: &width)
        }
        if (glyph == 0){
            let font = fonts[0].fallbackSystemFont(for: char)
            font?.layoutUnichar(char, glyph: &glyph, width: &width)
            if (glyph != 0){
                fallback = font
            }
        }
        return (width: width, glyph: glyph, font: fallback)
    }
    func layoutGlyphsFallback(){
        for index in 0..<unichars.count{
            let skchar = unichars[index]
            if glyphs[index] == 0 {
                let code = Unicode.Scalar(UInt32(skchar))
                guard let code = code else{
                    continue
                }
                if (Unicode.Scalar("\t") == code){
                    let space = Unicode.Scalar(" ").value
                    let result = layoutGlyphsFallbackChar(SkUnichar(space), font: fonts[0])
                    widths[index] = result.width * 4
                    glyphs[index] = result.glyph
                    if let font = result.font{
                        fonts.append(font)
                    }
                    indexOfFont[index] = fonts.count - 1
                    continue
                }
                if (skchar < 32){
                    continue
                }
                let result = layoutGlyphsFallbackChar(SkUnichar(skchar))
                if (result.glyph != 0){
                    glyphs[index] = result.glyph
                    widths[index] = result.width
                    if let font = result.font{
                        fonts.append(font)
                    }
                    indexOfFont[index] = fonts.count - 1
                }
            }
        }
    }
    func layoutGlyphsDefault(){
        let item = self
        let font = item.fonts[0]
        let unichars = item.unichars
        var glyphs = [SkGlyphID].init(repeating: 0, count: unichars.count)
        var widths = [SkScalar].init(repeating: 0, count: unichars.count)

        font.unichars(unichars, toGlyphs: &glyphs)
        font.layoutGlyphs(glyphs, widths: &widths)
        
        item.glyphs = glyphs
        item.widths = widths
        item.positions = [ScPoint].init(repeating: ScPoint.Make(0,0), count: unichars.count)
        item.indexOfFont = [Int].init(repeating: 0, count: unichars.count)
    }
}