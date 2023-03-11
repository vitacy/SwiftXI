@_exported import Foundation
//swift 5.8
@_expose(Cxx)
public class SkiaKit{
    var point = CGPoint.zero
    public init(){}
    public func myPoint() -> CGPoint{
        print("myPoint")
        return point
    }
    public func printPoint(){
        print("printPoint")
    }
    public func isOk() -> Bool{
        return true
    }
    public func getPoint() -> UnsafePointer<Bool>?{
        return nil
    }
}
@_expose(Cxx)
public struct SkiaKitStruct{
    var point = CGPoint.zero
    public init(){}
}
@_cdecl("_myKit")
public func myKit(){
    print("hello")
}
@_expose(Cxx)
public func myPoint() -> CGPoint{
    print("myPoint")
    return .init()
}
