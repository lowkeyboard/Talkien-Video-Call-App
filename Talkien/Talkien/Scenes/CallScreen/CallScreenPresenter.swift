
final class CallScreenPresenter: CallScreenPresenterProtocol {
    
    unowned var view: CallScreenViewProtocol
    
    init(view: CallScreenViewProtocol) {
        self.view = view
    }
    
    func load() {
        //deleted: view.update()
    }
}
