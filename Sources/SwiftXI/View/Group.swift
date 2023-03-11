public struct Group<Content> {
    var content: Content
    public typealias Body = Never
    init(_ c: Content){
        content = c
    }
}

extension Group : _NeverPublicBody {    
}
extension Group : Scene where Content : Scene {
    public init(@SceneBuilder content: () -> Content){
        self.init(content())
    }
}

extension Group : View where Content : View {
    public init(@ViewBuilder content: () -> Content){
        self.init(content())
    }
}


// extension Group : ToolbarContent where Content : ToolbarContent {
//     public init(@ToolbarContentBuilder content: () -> Content)
// }

// extension Group : CustomizableToolbarContent where Content : CustomizableToolbarContent {
//     public init(@ToolbarContentBuilder content: () -> Content)
// }

// extension Group : Commands where Content : Commands {
//     @inlinable public init(@CommandsBuilder content: () -> Content)
// }