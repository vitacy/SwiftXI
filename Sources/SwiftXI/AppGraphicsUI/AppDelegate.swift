class _AppDelegate: NSApplicationDelegate{
    let app: any App
    init<T: App>(_ app: T){
        self.app = app
    }
    func applicationDidFinishLaunching(_ application: UIApplication){
        let rootScene = app.body as! SceneASTBuilder
        let windowScene = rootScene.makeScenes()[0]
        let window = SwiftUIWindow.init()
        
        windowScene.window = window
        let root = AnyASTNode.makeRootView(scene: windowScene)

        window.setContentSize(.init(width: 600, height: 400))
        
        window.contentRoot = root
        window.title = "Swift HelloUI"
        window.makeKeyAndOrderFront(nil)
        window.viewsNeedDisplay = true
        print("application Actived")
    }
}
