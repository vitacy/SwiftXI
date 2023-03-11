public struct List<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {
    let selection: SelectionManagerBox?
    let content: Content

    enum SelectionManagerBox {
        case value(Binding<SelectionValue?>)
        case set(Binding<Set<SelectionValue>>)
    }
    public init(selection: Binding<Set<SelectionValue>>?, @ViewBuilder content: () -> Content){
        if let selection = selection{
            self.selection = .some(.set(selection))
        }else{
            self.selection = nil
        }
        self.content = content()
    }
    public init(selection: Binding<SelectionValue?>?, @ViewBuilder content: () -> Content){
        if let selection = selection{
            self.selection = .some(.value(selection))
        }else{
            self.selection = nil
        }
        self.content = content()
    }

    public var body: some View { 
        ScrollView(.vertical){
            VStack{
                Spacer().fixedSize(horizontal: false, vertical: true)
                content
                .onTapGesture {
                    selectIDValue()
                }
                .padding(EdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                Spacer().fixedSize(horizontal: false, vertical: true)
            }.onTapGesture {
                selectValue(nil)
            }
        }
    }
    func selectValue(_ value: SelectionValue?){
        print("select value \(String(describing: value))")
        switch selection{
            case .set(let b): 
                if value == .none  {
                    b.wrappedValue.insert(value!) 
                }else{
                    b.wrappedValue.removeAll()
                } 
            case .value(let v): v.wrappedValue = value
            case .none: break
        }
    }
    func selectIDValue(){
        var s: SelectionValue? = nil 
        _GestureContextValue.current?.fetchSelectID(&s)
        if let s = s{
            selectValue(s)
        }
    }
}

extension List {
    public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content==ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable{
        self.init(selection: selection){ 
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }

    // public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View{
        self.init(selection: selection){
            Content.init(data, id: id){  e in
                HStack{rowContent(e)}
            }
        }
    }

    //public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View


    public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View{
        self.init(selection: selection){
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }

    public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable{
        self.init(selection: selection){
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }

    //public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable


    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View{
        self.init(selection: selection){
            Content.init(data, id: id){  e in
                HStack{rowContent(e)}
            }
        }
    }

    //public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View

    public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View{
        self.init(selection: selection){
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }
}

extension List where SelectionValue == Never {
    public init(@ViewBuilder content: () -> Content){
        let select: Binding<Never?>? = nil
        self.init(selection: select){
            content()
        }
    }

    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable{
        let select: Binding<Never?>? = nil
        self.init(selection: select){
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }

    //public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable


    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View{
        let select: Binding<Never?>? = nil
        self.init(selection: select){
            Content.init(data, id: id){ e in 
                HStack{rowContent(e)}
            }
        }
    }

    //public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View

    public init<RowContent>(_ data: Range<Int>, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View{
        let select: Binding<Never?>? = nil
        self.init(selection: select){
            Content.init(data){  e in
                HStack{rowContent(e)}
            }
        }
    }
}


public struct ListItemTint {
    public static func fixed(_ tint: Color) -> ListItemTint{
        return .init()
    }
    public static func preferred(_ tint: Color) -> ListItemTint{
        return .init()
    }
    public static let monochrome: ListItemTint = .init()
}

public protocol ListStyle {
}

