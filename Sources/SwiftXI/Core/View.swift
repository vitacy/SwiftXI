public protocol View{
    associatedtype Body : View
    @ViewBuilder var body: Self.Body { get }
}




