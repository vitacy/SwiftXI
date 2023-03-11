struct _VStackLayoutChooser: _StackLayoutComputerChooser{
    func value(_ size: CGSize) -> CGFloat{
        return size.height
    }
    func setValue(_ size: inout CGSize, _ value: CGFloat){
        size.height = value
    }
    func minSizeProposal(_ size: CGSize) -> CGSize{
        var size = size
        size.height = 0
        return size
    }
}
struct _HStackLayoutChooser: _StackLayoutComputerChooser{
    func value(_ size: CGSize) -> CGFloat{
        return size.width
    }
    func setValue(_ size: inout CGSize, _ value: CGFloat){
        size.width = value
    }
    func minSizeProposal(_ size: CGSize) -> CGSize{
        var size = size
        size.width = 0
        return size
    }
}
protocol _StackLayoutComputerChooser{
    func value(_ size: CGSize) -> CGFloat
    func setValue(_ size: inout CGSize, _ value: CGFloat)
    func minSizeProposal(_ size: CGSize) -> CGSize
}
struct _StackLayoutComputer<T: _StackLayoutComputerChooser>{
    var proxy: T
    var minFreeLength = 0.01
    var limits = [LayoutSizeCache].init()
    
    var freeLength = CGFloat.zero
    var indices: [Int] = .init()
    var size: CGSize = .zero
    var currentPriority = CGFloat.infinity
    init(_ proxy: T = _VStackLayoutChooser()){
        self.proxy = proxy
    }
    struct LayoutSizeCache{
        var minSize: CGSize = .zero
        var maxSize: CGSize = .zero
        var size: CGSize = .zero
        var position: CGPoint = .zero
        var priority: CGFloat = .zero
    }
    
    var isFinished: Bool{
        return freeLength <= minFreeLength || currentPriority == -CGFloat.infinity
    }
    mutating func computeCurrentPriority(){
        var priority = -CGFloat.infinity
        limits.forEach{ v in
            if (v.priority > priority
                && v.priority < currentPriority
                && proxy.value(v.size) < proxy.value(v.maxSize)){
                priority = v.priority
            }
        }
        currentPriority = priority
    }
    mutating func computeSubviewsIndices(subviews: LayoutSubviews){
        let priority = currentPriority
        indices = subviews.indices.filter{ index in
            let v = limits[index]
            return v.priority == priority && proxy.value(v.size) < proxy.value(v.maxSize)
        }
    }
    mutating func computeSubviewsLimits(subviews: LayoutSubviews){
        subviews.enumerated().forEach{ (offset, v) in
            let minSize = v.sizeThatFits(.init(proxy.minSizeProposal(size)))
            let maxSize = v.sizeThatFits(.init(size))
            limits[offset].minSize = minSize
            limits[offset].size = minSize
            limits[offset].priority = v.priority
            limits[offset].maxSize = maxSize
        }
    }
    mutating func computeSubviewsSize(){
        while freeLength > minFreeLength && indices.count > 0{
            var flexible_min = indices.reduce(CGFloat.infinity){ min($0, proxy.value(limits[$1].size))}
            let step = freeLength / CGFloat(indices.count)
            flexible_min += step
            indices.forEach{ index in
                var result = flexible_min
                result = min(result, proxy.value(limits[index].maxSize))
                let last = proxy.value(limits[index].size)
                if result <= last {
                    return
                }
                freeLength -= (result - last)
                proxy.setValue(&limits[index].size, result)
            }
            
            indices = indices.filter{ index in
                let v = limits[index]
                return proxy.value(v.size) < proxy.value(v.maxSize)
            }
        }
    }
}

extension Alignment{
    func computeChildPosition(view: ViewDimensions, subview: ViewDimensions) -> CGPoint{
        let alignment = self
        let x = view[alignment.horizontal] - subview[alignment.horizontal]
        let y = view[alignment.vertical] - subview[alignment.vertical]
        return .init(x: x, y: y)
    }
    func computeChildPosition(viewSize: CGSize, subviewSize: CGSize) -> CGPoint{
        let view = ViewDimensions.init(size: viewSize)        
        let subview = ViewDimensions.init(size: subviewSize)
        return computeChildPosition(view: view, subview: subview)
    }
}