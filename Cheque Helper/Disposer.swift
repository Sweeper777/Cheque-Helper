import Combine

class Disposer {
    private var cancellables: [AnyCancellable]
    
    func append(_ item: AnyCancellable) {
        cancellables.append(item)
    }
    
    init() {
        cancellables = []
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
