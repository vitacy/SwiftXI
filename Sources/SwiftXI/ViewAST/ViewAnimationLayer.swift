class _ViewAnimationLayer{
    var size: CGSize = .zero
    var position: CGPoint = .zero
    var animation: Animation? = nil
    weak var value: _ViewElementNode? = nil
    
    var animatableData: CGRect.AnimatableData{
        get {frame.animatableData}
        set {
            frame.animatableData = newValue
            setNeedsDisplay()
        }
    }
    var frame: CGRect{
        get {.init(origin: position, size: size)}
        set{
            size = newValue.size
            position = newValue.origin
        }
    }

    func setNeedsDisplay(){
        value?.node.getWindow()?.windowNeedRedraw()
    }

    weak var _animationSource: _AnimationSource<_ViewAnimationLayer>? = nil
}

extension _ViewAnimationLayer: Animatable{
}

extension _ViewAnimationLayer{
    func withAnimation(_ body: (_ViewAnimationLayer)->()){
        guard let animation = value?.node.traits.animation else{
            body(self)
            return
        }
        let old = self.animatableData
        body(self)
        let value = self.animatableData

        if abs(value.magnitudeSquared - old.magnitudeSquared) < 0.01{
            return
        }
        if let source = _animationSource{
            if source.animation == animation {
                source.to = value
                return
            }
        }
        let source = _AnimationSource.init(self, animation: animation, from: old, value: value)
        source.doStart()
        AnimationDispather.shared.dispatch(source)
        _animationSource = source
    }
}

class _AnimationSource<T : Animatable>: _AnimationDispathSource{
    var owner: T
    var animation: Animation
    var startTime: Double = 0
    var from: T.AnimatableData
    var to: T.AnimatableData
    var isFinished = false

    init(_ owner: T, animation: Animation, from: T.AnimatableData, value: T.AnimatableData){
        self.owner = owner
        self.animation = animation
        self.from = from
        self.to = value
        self.startTime = self.nowTime()
        // print("from \(from) -> \(to)")
    }
    func doStart(){
        owner.animatableData = self.from
    }
    func nowTime() -> Double{
        return Date.timeIntervalSinceReferenceDate
    }
    func update(time: Double){
        let scale = animation.scaleValue(time)
        var value = to-from
        value.scale(by: scale)
        value += from
        owner.animatableData = value
        if (scale >= 1){
            self.isFinished = true
        }
    }
    func update(){
        let time = nowTime() - startTime
        update(time: time)
    }
}