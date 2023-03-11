import Foundation

protocol Copying{
    init(copyFrom: Self)
}
extension Copying where Self: AnyObject{
    func copy() -> Self{
        return type(of:self).init(copyFrom: self)
    }
}
class AnyASTNode: Copying {
    var depth = 0
    var id: AnyHashable? = nil
    
    var children = [AnyASTNode]()

    var environments: EnvironmentValues = .init()
    var traits = _TraitValues.init()
    var states: [String: Any] = [:]
    
    var scene: SceneASTNode? = nil
    weak var parent: AnyASTNode? = nil
    
    var needBuild = false

    var name: String{
        return String("\(_type)")
    }
    var _type: Any.Type{
        return type(of: self.value)
    }
    var any: Any { 
        return ()
    }
    var value: Any{
        get { return () }
        set {}
    }
    var isView: Bool {
        return false
    }
    fileprivate init(){
    }
    required init(copyFrom from: AnyASTNode){
        self.scene = from.scene

        self.environments = from.environments
        self.traits = from.traits
        self.states = from.states

        self.depth = from.depth
    }

    func dump(_ space: String = "") {
        print("\(space)\(name) +++ \(type(of:any))")
        children.forEach { n in
            n.dump(space + "----")
        }
    }
    func createModifierContextValue() -> _ViewElementNode?{
        if let obj = self.any as? _ViewElementNodeCreator{
            let value = obj._viewContextCreate(node: self)
            return value
        }
        return nil
    }
    func createViewContextValue() -> _ViewElementNode{
        if (traits.isStack){
            return _StackViewElementNode.init(self)
        }
        return .init(self)
    }
    func makeRenderTree(root: _StackViewElementNode, modfiers nodes: [AnyASTNode], caches: [_ViewElementNode]){
        if (self.isView && self.traits.isStack) 
        || children.count == 0{
            let value = root.makeChildValue(node: self, caches: caches)
            value.updateModifiers(nodes: nodes)
            if (value.isStackRoot && !traits.isLazy){
                (value as! _StackViewElementNode).makeRenderTree()
            }
        }else{
            let m = nodes + [self]
            children.forEach{ child in
                child.makeRenderTree(root: root, modfiers: m, caches: caches)
            }
        }
    }

    func _rebuildView(){
    }
    func updateAnimation(){
    }
}
class AnyValueASTNode<Value>: AnyASTNode{
    var _value: Value
    init(_ value: Value){
        _value = value
        super.init()
    }
    override var any: Any{
        return _value
    }
    override var value: Any{
        get { return _value }
        set { _value = newValue as! Value }
    }
    required init(copyFrom: AnyASTNode){
        _value = (copyFrom as! AnyValueASTNode<Value>)._value
        super.init(copyFrom: copyFrom)
    }
}
class ViewASTNode<Value: View>: AnyValueASTNode<Value>{
    override var isView: Bool {
        return true
    }
    override func _rebuildView(){
        self._buildBodyViewDefault(view: _value)
    }
}

class ViewModifierASTNode<Content: View, Modifier: ViewModifier>: AnyValueASTNode<ModifiedContent<Content, Modifier>>{
    override var any: Any{
        return modifier
    }
    var modifier: Modifier{
        get {return _value.modifier}
        set {_value.modifier = newValue}
    }
}
class AnimatableModifierASTNode<Content: View, Modifier: AnimatableModifier>: ViewModifierASTNode<Content, Modifier>{
    var oldAnimatableData = Modifier.AnimatableData.zero
    override var any: Any{
        return _value.modifier
    }
    override var value: Any{
        willSet{
            oldAnimatableData = modifier.animatableData
        }
    }
    weak var _animationSource: _AnimationSource<AnimatableProxy>? = nil
    override func updateAnimation(){
        guard let animation = self.traits.animation else{
            return
        }
        if let source = _animationSource{
            if source.animation == animation {
                source.to = modifier.animatableData
                return
            }
        }
        if oldAnimatableData == modifier.animatableData{
            return
        }
        let source = _AnimationSource.init(AnimatableProxy.init(node: self), animation: animation, from: oldAnimatableData, value: modifier.animatableData)
        source.doStart()
        AnimationDispather.shared.dispatch(source)
        _animationSource = source
    }

    struct AnimatableProxy: Animatable{
        var node: AnimatableModifierASTNode
        var animatableData: Modifier.AnimatableData{
            get {node.modifier.animatableData}
            set {
                node.modifier.animatableData = newValue
                // node.update()
            }
        }
    }
}

extension AnyASTNode {
    static func makeRootView(scene: SceneASTNode, environments: EnvironmentValues = .init()) -> _StackViewElementNode {
        let renderView = scene.value as! AnyASTNodeBuilder
        let node = AnyValueASTNode(renderView)
        node.scene = scene
        node.environments = environments
        node.traits.isStack = true
        
        renderView._buildViews(node: node)
        let value = _StackViewElementNode(node)
        value.makeRenderTree()
        return value
    }
}

protocol ViewNode {
    func update()
}
extension AnyASTNode: ViewNode {
    func update() {
        needBuild = true
        ViewRebuilder.shared.rebuild(self)
        // print("view node updated")
    }
    func stateForKey(_ key: String) -> Any? {
        return states[key]
    }
    func setStateForKey(_ state: Any, forKey: String) {
        states[forKey] = state
    }
    func getWindow() -> SwiftUIWindow? {
        if scene?.window != nil {
            return scene?.window
        }
        return parent?.getWindow()
    }
}


struct _IsStackLayoutTraitKey: _ViewTraitKey{
    static var defaultValue: Bool {
        return false
    }
}
struct _LazyMakeChildrenTraitKey: _ViewTraitKey{
    static var defaultValue: Bool {
        return false
    }
}
struct _AnimationTraitKey: _ViewTraitKey{
    static var defaultValue: Animation? {
        return nil
    }
}

extension _TraitValues {
    var isStack: Bool {
        get { return self[_IsStackLayoutTraitKey.self] }
        set { self[_IsStackLayoutTraitKey.self] = newValue }
    }
    var isLazy: Bool {
        get { return self[_LazyMakeChildrenTraitKey.self] }
        set { self[_LazyMakeChildrenTraitKey.self] = newValue }
    }
    var animation: _AnimationTraitKey.Value {
        get { return self[_AnimationTraitKey.self] }
        set { self[_AnimationTraitKey.self] = newValue }
    }
}

struct _TextDataTraitKey: _ViewTraitKey{
    static var defaultValue: Text._TextViewData? {
        return nil
    }
}
extension _TraitValues{
    var _textViewData: _TextDataTraitKey.Value {
        get { return self[_TextDataTraitKey.self] }
        set { self[_TextDataTraitKey.self] = newValue }
    }
}
struct _ImageDataTraitKey: _ViewTraitKey{
    static var defaultValue: _ImageViewContent? {
        return nil
    }
}
extension _TraitValues{
    var _imageViewData: _ImageDataTraitKey.Value {
        get { return self[_ImageDataTraitKey.self] }
        set { self[_ImageDataTraitKey.self] = newValue }
    }
}
struct _EventCtxDataTraitKey: _ViewTraitKey{
    static var defaultValue: _HoverRegionModifier._EventCtxData? {
        return nil
    }
}
extension _TraitValues{
    var _eventCtxData: _EventCtxDataTraitKey.Value {
        get { return self[_EventCtxDataTraitKey.self] }
        set { self[_EventCtxDataTraitKey.self] = newValue }
    }
}
struct _LayoutTraitKey: _ViewTraitKey{
    static var defaultValue: (any Layout)? {
        return nil
    }
}
extension _TraitValues{
    var layout: _LayoutTraitKey.Value {
        get { return self[_LayoutTraitKey.self] }
        set { self[_LayoutTraitKey.self] = newValue }
    }
}

