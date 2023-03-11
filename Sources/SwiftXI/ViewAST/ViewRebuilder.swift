
extension Transaction{
    struct _RebuildNodesKey : _TransactionKey{
        static var defaultValue: Box<[AnyASTNode]>? {
            return nil
        }
    }
    var astNodes: [AnyASTNode] {
        get {return self[_RebuildNodesKey.self]?.wrappedValue ?? .init()}
        set {
            var box = self[_RebuildNodesKey.self]
            if (box == nil){
                box = .some(.init(initialValue: .init()))
                self[_RebuildNodesKey.self] = box
            }
            box?.wrappedValue = newValue 
        }
    }
}
protocol _AnimationDispathSource{
    func update()
    var isFinished: Bool {get}
}
final class AnimationDispather{
    static let shared = AnimationDispather.init()
    var sources = [_AnimationDispathSource].init()
    var timer: DispatchSourceTimer? = nil
    
    func installTimer(){
        guard timer == nil else{
            return
        }
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 0.01)
        timer?.setEventHandler {
            self.doAnimationOnceMain()
        }
        timer?.resume()
    }
    func removeTimer(){
        timer?.cancel()
        timer = nil
    }
    func doAnimationOnceMain(){
        let curSources = self.sources
        curSources.forEach{$0.update()}
        self.sources = self.sources.filter{!$0.isFinished}
        if self.sources.count == 0{
            removeTimer()
        }
    }
    func dispatch(_ source: _AnimationDispathSource){
        self.sources.append(source)
        installTimer()
    }
    func remove(_ node: AnyASTNode){

    }
}

final class ViewRebuilder {
    static let shared = ViewRebuilder.init()

    func rebuild(_ view: AnyASTNode) {
        Transaction.current.astNodes.append(view)
        DispatchQueue.main.async {
            self.rebuild()
        }
    }

    func rebuild() {
        var transactions = Transaction.transactions
        transactions.append(Transaction.current)

        Transaction.current = .init()
        Transaction.transactions = .init()

        var window: SwiftUIWindow? = nil
        transactions.forEach{ t in
            let nodes = t.astNodes.sorted{$0.depth < $1.depth}
            nodes.forEach{ node in
                node._rebuildView()
                print("rebuild \(node.needBuild) \(type(of:node.any))")
                if window == nil {
                    window = node.getWindow()
                }
            }
        }

        window?._renderRoot?.makeRenderTree()
        window?.layoutWindowNode()
    }
}