
// MARK: - Interactor

protocol MainScreenInteractorProtocol: class {
    var delegate: MainScreenInteractorDelegate? { get set }
    func load()
    func selectMovie(at index: Int)
}

enum MainScreenInteractorOutput: Equatable {
    case setLoading(Bool)

}

protocol MainScreenInteractorDelegate: class {
    func handleOutput(_ output: MainScreenInteractorOutput)
}

// MARK: - Presenter

protocol MainScreenPresenterProtocol: class {
    func load()
    func selectMovie(at index: Int)
}

enum MainScreenPresenterOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
}

// MARK: - View

protocol MainScreenViewProtocol: class {
    func handleOutput(_ output: MainScreenPresenterOutput)
}

// MARK: - Router

enum MainScreenRoute: Equatable {
    case detail
}

protocol MainScreenRouterProtocol: class {
    func navigate(to route: MainScreenRoute)
}
