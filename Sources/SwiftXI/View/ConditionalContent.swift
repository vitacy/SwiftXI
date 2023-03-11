public struct _ConditionalContent<TrueContent, FalseContent>: View where TrueContent: View, FalseContent: View {
    public enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
    public let _storage: Storage
    
    init(storage: Storage) {
        _storage = storage
    }
}

extension _ConditionalContent : _NeverPublicBody{
}