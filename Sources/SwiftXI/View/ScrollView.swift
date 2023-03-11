public struct ScrollView<Content> : View where Content : View {
    public var content: Content
    public var axes: Axis.Set
    public var showsIndicators: Bool

    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    var sizeReader = _ScrollerViewContentSizeObject.init()

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content){
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        HStack(spacing: 0){
            if axes.contains(.vertical) && axes != .vertical{
                Spacer(minLength: 0).fixedSize(horizontal: false, vertical: true)
            }
            VStack(spacing: 0){
                if axes.contains(.horizontal) && axes != .horizontal{
                    Spacer(minLength: 0).fixedSize(horizontal: true, vertical: false)
                }
                content.background(GeometryReader{ p in
                            let _ = (sizeReader.size = p.size)
                        }).offset(x: -offsetX, y: -offsetY)
                        .fixedSize(horizontal: axes != .vertical , vertical: axes != .horizontal)
                if axes != .horizontal{
                    Spacer(minLength: 0).fixedSize(horizontal: true, vertical: false)
                }
            }
            if axes != .vertical{
                Spacer(minLength: 0).fixedSize(horizontal: false, vertical: true)
            }
        }
        .clipped()
        .frame(minWidth: axes == .vertical ? nil : 0, maxWidth: axes == .vertical ? nil : .infinity,
                     minHeight: axes == .horizontal ? nil : 0, maxHeight: axes == .horizontal ? nil : .infinity,
                     alignment: .topLeading)
        .overlay(show: axes.contains(.vertical), view: 
            HStack{
                _ScrollerView(offset: $offsetY, contentSizeReader: sizeReader, vertical: true).frame(width: 10)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        ).overlay(show: axes.contains(.horizontal), view: 
            VStack{
                _ScrollerView(offset: $offsetX, contentSizeReader: sizeReader, vertical: false).frame(height: 10)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        ).overlay(
            GeometryReader{ p in
                let _ = (sizeReader.scrollViewSize = p.size)
                Color.clear.onScrollWheel{ delta in 
                    let y = offsetY - 5 * delta.height
                    let x = offsetX - 5 * delta.width

                    offsetX = max(min(x, sizeReader.size.width - sizeReader.scrollViewSize.width), 0)
                    offsetY = max(min(y, sizeReader.size.height - sizeReader.scrollViewSize.height), 0)
                }
        })
        
    }
}

extension View{
     fileprivate func overlay<Overlay: View>(show: Bool = true, view: Overlay) -> some View {
        let v: Overlay? =  show ? view : nil;
        return self.overlay(v)
    }
}

class _ScrollerViewContentSizeObject : ObservableObject{
    @Published var size = CGSize.zero
    @Published var scrollViewSize = CGSize.zero
    init(){}
}
struct _ScrollerView: View{
    @State var showBg = false
    @Binding var offset: CGFloat
    var contentSizeReader: _ScrollerViewContentSizeObject
    var vertical: Bool

    var body: some View{
        VStack{ GeometryReader { p in
            let data: _ScrollerViewData = {
                    var data = _ScrollerViewData.init()
                    data.size = p.size
                    data.offset = self.offset
                    data.contentSize = contentSizeReader.size
                    data.vertical = vertical
                    return data
            }()
            ZStack(alignment: vertical ? .top : .leading){
                Capsule().frame(width: vertical ? nil : data.length,height: vertical ? data.length : nil)
                .padding(1).offset(x: vertical ? 0 : data.scrollerOffset, y: vertical ? data.scrollerOffset : 0)

                Color.clear
                .gesture(DragGesture(minimumDistance: 0) 
                    .onChanged{ v in 
                        self.offset = data.offsetAtPoint(v.location)
                    })
            }
            
        }}.background(showBg ? Color.gray : Color.clear)
        .onHover{ b in
            showBg = b
        }
    }
}

public struct ScrollViewProxy {
    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint? = nil) where ID : Hashable{

    }
}

public struct ScrollViewReader<Content> : View where Content : View {
    public var content: (ScrollViewProxy) -> Content
    public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content){
        self.content = content
    }
    public var body: some View {
        content(ScrollViewProxy.init())
    }
}

struct _ScrollerViewData{
    var vertical: Bool = true
    var size = CGSize.zero
    var contentSize = CGSize.zero
    var offset: CGFloat = 0

    var length: CGFloat{
        if sizeChooser(contentSize) <= sizeChooser(size){
            return sizeChooser(size)
        }
        let length = sizeChooser(size)/sizeChooser(contentSize) * sizeChooser(size)
        return max(length.rounded(), 80)
    }

    var scrollerOffset: CGFloat{
        let maxOffset = sizeChooser(size) - self.length
        let maxContentOffset = max(1, sizeChooser(contentSize) - sizeChooser(size))
        let offset = (self.offset / maxContentOffset)*maxOffset
        return max(min(offset, maxOffset),0)
    }

    var scrollerBounds: CGRect{
        var rect = CGRect.zero
        rect.size = size
        if vertical {
            rect.size.height = self.length
            rect.origin.y = self.scrollerOffset
        }else{
            rect.size.width = self.length
            rect.origin.x = self.scrollerOffset
        }
        return rect
    }

    func offsetAtPoint(_ point: CGPoint) -> CGFloat{
        let maxOffset = sizeChooser(size) - self.length
        let maxContentOffset = max(1, sizeChooser(contentSize) - sizeChooser(size))
        let result = (pointChooser(point) - self.length*0.5)/maxOffset * maxContentOffset
        return  max(min(result, maxContentOffset), 0)
    }

    func sizeChooser(_ size: CGSize) -> CGFloat{
        if vertical {
            return size.height
        }
        return size.width
    }
    func pointChooser(_ point: CGPoint) -> CGFloat{
        if vertical {
            return point.y
        }
        return point.x
    }
}