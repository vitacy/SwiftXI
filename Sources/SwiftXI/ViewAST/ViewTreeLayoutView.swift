

extension Text: ComputableLayout {
    class _TextViewData{
        let text: _TextViewDrawContext
        let idealSize: CGSize 
        var lastWidth: CGFloat = 0
        init(text: _TextViewDrawContext, idealSize: CGSize){
            self.text = text
            self.idealSize = idealSize
        }
    }
    func makeTextViewData(value: _ViewElementNode) {
        var itemData: _TextViewData? = value.node.traits._textViewData
        if itemData == nil {
            let text = _TextViewDrawContext.init(self.attributedStringValue)
            text.doLayout()
            itemData = _TextViewData.init(text: text, idealSize: text.size)
            value.node.traits._textViewData = itemData
        }
    }
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        let value = proxy.current
        makeTextViewData(value: value)
        guard let itemData = value.node.traits._textViewData else {
            return .zero
        }
        var result = CGSize.zero
        switch proposal.width{
            case 0:
                result.width = itemData.idealSize.width
                result.height = itemData.idealSize.height
            case CGFloat.infinity: 
                result.width = itemData.idealSize.width
                result.height = itemData.idealSize.height
            case .none:
                result.width = itemData.idealSize.width
                result.height = itemData.idealSize.height
            case .some(let width):
                if !itemData.lastWidth.isAboutEqual(width){
                    itemData.text.layoutWith(width: width)
                    itemData.lastWidth = width
                }
                result.width = itemData.text.size.width
                result.height = itemData.text.size.height
        }
        return result
    }
    
    func layoutConfigView(value: _ViewElementNode){
        self.defaultLayoutConfigView(value: value)
    }
}

extension Image: ComputableLayout {
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        let value = proxy.current

        if value.node.traits._imageViewData == nil {
            let itemData = self._getRenderImage()
            value.node.traits._imageViewData = itemData
        }
        guard let content = value.node.traits._imageViewData else{
            return .zero
        }
        let result = content.image.size
        if content.resizingMode == nil{
            return result
        }
        return proposal.replacingUnspecifiedDimensions(by: result)
    }
    func layoutConfigView(value: _ViewElementNode){
        self.defaultLayoutConfigView(value: value)
    }
}

extension _ShapeView: ComputableLayout {
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        return proposal.replacingUnspecifiedDimensions()
    }
    func layoutConfigView(value: _ViewElementNode){
        self.defaultLayoutConfigView(value: value)
    }
}

extension Divider: ComputableLayout{
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        var result = proposal.replacingUnspecifiedDimensions()
        let value = proxy.current
        let layout = value.stack?.node.value as? _LayoutPropertiesGetter
        switch layout?.layoutProperties.stackOrientation{
            case .horizontal: result.height = 1
            case .vertical: result.width = 1
            default:
                result.height = 1
                break
        }
        return result
    }
    
    func layoutConfigView(value: _ViewElementNode){
        self.defaultLayoutConfigView(value: value)
    }
}
extension Spacer: ComputableLayout {
    static var defaultSpacing: CGFloat {return 8}
    func sizeThatFits(_ proposal: ProposedViewSize, proxy: _LayoutNodeProxy) -> CGSize{
        let length = minLength ?? Self.defaultSpacing
        var result = proposal.replacingUnspecifiedDimensions(by: .zero)
        result = result.replacing(minSize: .init(width: length, height: length))
        return .init(width: max(result.width, length), height: max(result.height, length))
    }
}

