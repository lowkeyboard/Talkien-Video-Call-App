

final class MovieListPresenter: MovieListPresenterProtocol {
    
    private unowned let view: MovieListViewProtocol
//    private let interactor: MovieListInteractorProtocol
    private let router: MovieListRouterProtocol
    
    
    init(view: MovieListViewProtocol,
//         interactor: MovieListInteractorProtocol,
         router: MovieListRouterProtocol) {
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

extension MovieListPresenter: MovieListInteractorDelegate {
    
    func handleOutput(_ output: MovieListInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view.handleOutput(.setLoading(isLoading))
    }
}
}
