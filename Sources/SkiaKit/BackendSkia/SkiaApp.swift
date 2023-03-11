

public class SkiaApp{
    static let shared = SkiaApp.init()
    func start() {
        let app = SC.Application.shared()
        app?.pointee.run()
    }
    func stop() {
        let app = SC.Application.shared()
        app?.pointee.quit()
    }
}

@_cdecl("SwiftSkiaAppIdle")
func SwiftSkiaAppIdle(_ time: Double){
    struct _IdleTick{
        static var tick=0
    }
    _IdleTick.tick += 1
    var time = time
    if time == 0{
        time = 0.004
    }
    _ = RunLoop.current.run(mode: .default, before: Date()+time)
}

@_cdecl("SwiftSkiaAppActivate")
func SwiftSkiaAppActivate(){
    NSApplication.shared.delegate?.applicationDidFinishLaunching(NSApplication.shared)
}

struct CXXSwiftInterop {
    static let shared = CXXSwiftInterop()
        func cxx_pointer_from_swift_object<T: AnyObject>(_ ptr: T) -> UnsafeMutableRawPointer {
        return Unmanaged<T>.passUnretained(ptr).toOpaque()
    }
    func cxx_pointer_to_swift_object<T: AnyObject>(_ ptr: UnsafeMutableRawPointer) -> T{
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }

    func retain<T: AnyObject>(_ ptr: UnsafeMutableRawPointer, _ type: T.Type){
        let _ = Unmanaged<T>.fromOpaque(ptr).retain()
    }
    func release<T: AnyObject>(_ ptr: UnsafeMutableRawPointer, _ type: T.Type){
        Unmanaged<T>.fromOpaque(ptr).release()
    }
}
