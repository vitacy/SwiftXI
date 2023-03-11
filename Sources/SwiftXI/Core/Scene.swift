public protocol Scene {
    associatedtype Body: Scene
    @SceneBuilder var body: Self.Body { get }
}
