import SwiftUI
import XCTest

import class Foundation.Bundle

final class swiftuiTests: XCTestCase {
    func testPath() {
        var m1 = Path.init(CGRect.init(x: 0, y: 0, width: 200, height: 200)).strokedPath(.init(lineWidth: 20))
        m1.addRect(.init(x: 1, y: 2, width: 3, height: 4))
        m1.move(to: .init(x: 0, y: 1))
        m1.addCurve(to: .init(x: 1, y: 2), control1: .init(x: 3, y: 4), control2: .init(x: 5, y: 6))
        //m1.addQuadCurve(to: .init(x: 7.1/9.123, y: 8), control: .init(x: Double.infinity, y: 10))
        //m1.move(to: .init(x: Double.infinity, y: Double.nan))
        print("m1 is \(m1)")
        let m2 = Path.init(m1.description)
        print("m2 is \(m2!)")
        print("m1 is = m2 \(m1.description == m2!.description)")
        print("nan == nan \(Double.infinity==Double.infinity)")
    }
    func testColor() {
        var p = Color(.displayP3, red: 1, green: 0.2, blue: 0.3, opacity: 0.4)
        print("\(p)")
        p = Color(.sRGB, red: 1, green: 0.3, blue: 0.3, opacity: 0.4)
        //mirrorObject(p)
        print("\(p)")
        p = Color(.sRGBLinear, red: 1, green: 0.2, blue: 0.3, opacity: 0.4)
        print("\(p)")
        p = Color.init(hue: 1, saturation: 0.2, brightness: 0.3)
        print("\(p)")
        p = Color.init(hue: 0.6, saturation: 0.6, brightness: 0.6)
        print("\(p)")
        // DisplayP3(red: 1.0, green: 0.2, blue: 0.3, opacity: 0.4)
        // #FF334C66
        // #FF7C9566
        // #4C3D3DFF
        // #3D6299FF
        // for i in 0...255 {
        //     var red = Double(i)/255.0
        //     let a=Color.init(hue: red, saturation: red, brightness: red)
        //     let b=Color.hsv2rgb(h: red, s: red, v: red)
        //     var c=Color.init(red: b.red, green: b.green, blue: b.blue)
        //     // let b=hsv2rgb(h: red*360, s: red, v: red)
        //     // var c=Color.init(red: b.r, green: b.g, blue: b.b)
        //     print("color hsb \(a) \(c)")
        // }
    }
    func testCGAffineTransform() {
        var trans = CGAffineTransform.init(translationX: 100, y: 100)
        print("trans 1 \(trans)")
        trans = trans.scaledBy(x: 2, y: 3)
        print("trans 2 \(trans)")
        trans = trans.rotated(by: CGFloat(Double.pi) * 0.7)
        trans = trans.translatedBy(x: 50, y: 50)
        print("trans 3 \(trans)")
        let trans_t = CGAffineTransform.init(translationX: 200, y: -300).rotated(by: CGFloat(Double.pi))
        print("trans 4 \(trans_t)")
        print("trans 5 \(trans_t.concatenating(trans))")
        print("trans 6 \(trans.concatenating(trans_t))")
        print("trans 7 \(CGSize.init(width: 100, height: 100).applying(trans))")
        print("trans 8 \(CGPoint.init(x: 100, y: 100).applying(trans))")

        var path = Path()
        let rect = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        path.addRect(rect)
        trans = CGAffineTransform.identity
        trans = trans.rotated(by: CGFloat(Angle.init(degrees: 45).radians))
        path = path.applying(trans)
        print("path \(path)")
    }
    
    func testSwiftXI(){
        // let _ = _SkiaFontManager.shared.availableFontFamilies
        // let _ = _SkiaFontManager.shared.availableFonts

        let font = NSFont.init(name: "宋体 Bold", size: 30)!
        print("font.fontName \(font.fontName)")
        print("font.familyName \(font.familyName!)")
        print("font.pointSize \(font.pointSize)")
        // print("font == \(Font.custom( "123", fixedSize: 10)==Font.custom("124", fixedSize: 10))")
        // print("font == \(Font.custom( "123", fixedSize: 10)==Font.custom("123", fixedSize: 10))")
        // let _ = print("bold font \(Font.system(size: 40).bold().nsFont())")
        // let _ = print("bold italic font \(Font.system(size: 40).italic().weight(.bold).nsFont())")
        // print("\(Bundle.main.executablePath ?? "no executablePath")")
        print("\(Bundle.main.path(forResource: "SwiftHello", ofType: "o") ?? " can not find SwiftHello.o")")
        let image = NSImage.init(named: "icon")
        if let image = image{
            print("nsimage : \(image) \(image.size)")
        }
        // print("Edge \(Edge.Set.horizontal)")
        // // print("skcanvas \(SkCanvas.self)")
        // print("SkFont \(SkFont.self)")
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)

            let fooBinary = productsDirectory.appendingPathComponent("SwiftHello")

            let process = Process()
            process.executableURL = fooBinary

            let pipe = Pipe()
            process.standardOutput = pipe

            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)

            XCTAssertEqual(output, "Hello, world!\n")
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }
}
