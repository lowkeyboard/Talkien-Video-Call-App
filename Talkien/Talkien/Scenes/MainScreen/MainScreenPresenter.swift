

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    private unowned let view: MainScreenViewProtocol
//    private let interactor: MainScreenInteractorProtocol
    private let router: MainScreenRouterProtocol
    
    
    init(view: MainScreenViewProtocol,
//         interactor: MainScreenInteractorProtocol,
         router: MainScreenRouterProtocol) {
        self.view = view
//        self.interactor = interactor
        self.router = router
        
        
//        self.interactor.delegate = self
    }
    
    func load() {
        view.handleOutput(.updateTitle("Movies"))
//        interactor.load()
    }
    
    func selectMovie(at index: Int) {
//        interactor.selectMovie(at: index)
        router.navigate(to: .detail)
    }
}

extension MainScreenPresenter: MainScreenInteractorDelegate {
    
    func handleOutput(_ output: MainScreenInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view.handleOutput(.setLoading(isLoading))
    }
}
}
