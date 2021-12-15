
// MARK: - Interactor

protocol MovieListInteractorProtocol: class {
    var delegate: MovieListInteractorDelegate? { get set }
    func load()
    func selectMovie(at index: Int)
}

enum MovieListInteractorOutput: Equatable {
    case setLoading(Bool)

}

protocol MovieListInteractorDelegate: class {
    func handleOutput(_ output: MovieListInteractorOutput)
}

// MARK: - Presenter

protocol MovieListPresenterProtocol: class {
    func load()
    func selectMovie(at index: Int)
}

enum MovieListPresenterOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
}

// MARK: - View

protocol MovieListViewProtocol: class {
    func handleOutput(_ output: MovieListPresenterOutput)
}

// MARK: - Router

enum MovieListRoute: Equatable {
    case detail
}

protocol MovieListRouterProtocol: class {
    func navigate(to route: MovieListRoute)
}
