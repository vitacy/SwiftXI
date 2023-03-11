extension View {
    public func id<ID>(_ id: ID) -> some View where ID : Hashable{
        return IDView.init(content: self, id: id)
    }
    public func tag<V>(_ tag: V) -> some View where V : Hashable{
        return modifier(_TraitWritingModifier<TagValueTraitKey<V>>.init(value: .tagged(tag)))
    }
}

struct IDView<T: View, ID: Hashable> : View{
    let content: T
    let id: ID
}

extension IDView : _NeverInternalBody{
}

enum TagValueTraitKey<T: Hashable>: Hashable, _ViewTraitKey{
    case none
    case tagged(T)
    static var defaultValue: TagValueTraitKey {
        return none
    }
}
