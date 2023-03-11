
public struct Button<Label> : View where Label : View {
    let _label: Label
    let action: ()->()
    init(label: Label, action: @escaping () -> Void){
        self.action = action
        self._label = label
    }
    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label){
        self.init(label: label(), action: action)
    }
}
extension Button : _NeverPublicBody{
}

extension Button where Label == Text {
    public init(_ titleKey: LocalizedStringKey, action: @escaping () -> Void){
        self.init(label: Text(titleKey), action: action)
    }
    public init<S>(_ title: S, action: @escaping () -> Void) where S : StringProtocol{
        self.init(label: Text(title), action: action)
    }
}

extension Button where Label == PrimitiveButtonStyleConfiguration.Label {
    public init(_ configuration: PrimitiveButtonStyleConfiguration){
        self.init(label: configuration.label, action: configuration.action) 
    }
}

public protocol PrimitiveButtonStyle {
    associatedtype Body : View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = PrimitiveButtonStyleConfiguration
}

public struct PrimitiveButtonStyleConfiguration {
    public struct Label : View {
        let content: AnyView
    }
    public let label: PrimitiveButtonStyleConfiguration.Label
    let action: ()->()

    init<Content: View>(_ view: Content, action: @escaping ()->()){
        self.label = .init(content: .init(view))
        self.action = action
    }
    public func trigger(){
        action()
    }
}
extension PrimitiveButtonStyleConfiguration.Label : _NeverPublicBody{
}

struct _ButtonPressReader<T: View>: View{
    @State var isPressed = false
    var content : (Bool)->T
    var body: some View {
        content(isPressed).overlay(GeometryReader{ p in
            Color.clear
            .simultaneousGesture( 
                        DragGesture(minimumDistance: 0)
                        .onChanged{ v in updatePressdState(true, point: v.location, viewSize: p.size)  }
                        .onEnded{ _ in updatePressdState(false) }
                     )
        })
    }
    func updatePressdState(_ pressed: Bool, point: CGPoint = .zero, viewSize: CGSize = .zero){
        if (pressed){
            let rect = CGRect.init(origin: .zero, size: viewSize)
            if rect.contains(point) != isPressed {
                isPressed = !isPressed
            }
        }else{
            isPressed = false
        }
    }
    init(@ViewBuilder content: @escaping (Bool)->T){
        self.content = content
    }
}
public struct DefaultButtonStyle : PrimitiveButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View{
        _ButtonPressReader{ pressed in 
            let color = pressed ? Color.green : Color.white
            configuration.label
            .padding(EdgeInsets.init(top: 1, leading: 8, bottom: 1, trailing: 8))
            .background(RoundedRectangle(cornerRadius:5).fill(color).padding(1))
            .overlay(RoundedRectangle(cornerRadius:5).stroke(Color.white.opacity(0.3)))
            .onTapGesture(perform: configuration.trigger)
            }
        }
}
public struct LinkButtonStyle : PrimitiveButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View{
        configuration.label
      .onTapGesture(perform: configuration.trigger)
    }
}

public struct PlainButtonStyle : PrimitiveButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View{
        configuration.label
      .onTapGesture(perform: configuration.trigger)
    }
}
public struct BorderedButtonStyle : PrimitiveButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View{
        configuration.label
      .onTapGesture(perform: configuration.trigger)
    }
}
public struct BorderlessButtonStyle : PrimitiveButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View{
        configuration.label
      .onTapGesture(perform: configuration.trigger)
    }
}