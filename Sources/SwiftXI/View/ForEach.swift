public struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable {
    public var data: Data
    public var content: (Data.Element) -> Content
    let idGenerator: IDGenerator

    enum IDGenerator{
        case offset
        case keyPath(KeyPath<Data.Element, ID>)
    }
}

extension ForEach : View where Content : View {
    public typealias Body = Never
}


extension ForEach where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content){
        self.data = data
        self.content = content
        self.idGenerator = .keyPath(\Data.Element.id)
    }
}

extension ForEach where Content : View {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content){
        self.data = data
        self.content = content
        self.idGenerator = .keyPath(id)
    }
}

extension ForEach where Data == Range<Int>, ID == Int, Content : View {
    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content){
        self.data = data
        self.content = content
        self.idGenerator = .offset
    }
}

extension ForEach : _NeverPublicBody{
}
// extension ForEach : DynamicViewContent where Content : View {
// }