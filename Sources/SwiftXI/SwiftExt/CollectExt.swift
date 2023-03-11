extension Array where Element: Equatable {
    mutating func removeFirst(element: Element) {
        guard let index = firstIndex(of: element) else {return}
        remove(at: index)
    }

    
}

extension Array{
    func forEachPair2(_ append: Element, body: (Element, Element) -> Void){
        guard self.count > 0 else{
            return
        }

        var last = self[0]
        self[1 ..< self.count].forEach{ e in
            body(last, e)
            last = e
        }
        body(last, append)
    }
    func forEach(_ append: Element, body: (Element) -> Void){
        self.forEach{
            body($0)
        }
        body(append)
    }
    mutating func mutatingForEach(by transform: (inout Element) throws -> Void) rethrows {
        for index in self.indices{
            try transform(&self[index])
        }
     }
}
