
extension NSFontManager{
    var availableFontsImpl: [String] {
         var fonts = [String]()
        withUnsafePointer(to: &fonts) { p in
            let pointer : UnsafeMutableRawPointer = UnsafeMutableRawPointer.init(mutating: p)
            ScFont.getAllFontNames(pointer)
        }
        print("fonts \(fonts)")
        return fonts
    }
    var availableFontFamiliesImpl: [String] {
        var families = [String]()
        withUnsafePointer(to: &families) { p in
            let pointer : UnsafeMutableRawPointer = UnsafeMutableRawPointer.init(mutating: p)
            ScFont.getAllFontFamilies(pointer)
        }
        print("families \(families)")
        return families
    }
}
@_cdecl("SwiftStringArrayAddUtf8StringItem")
func SwiftStringArrayAddUtf8StringItem(_ arrPointer: UnsafeMutableRawPointer, str: UnsafeMutablePointer<ScString>){
    let arr = arrPointer.assumingMemoryBound(to: [String].self)
    arr.pointee.append(str.pointee.toString());
}

