class Observable<Value> {
    
    typealias Listener = (Value) -> Void
    
    private var listener: Listener?
    
    var value: Value {
        didSet { listener?(value) }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func observe(_ listener: @escaping Listener) {
        self.listener = listener
    }
}
