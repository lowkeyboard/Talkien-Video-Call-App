
// MARK: - Interactor

protocol MainScreenInteractorProtocol: AnyObject {
    var delegate: MainScreenInteractorDelegate? { get set }
    func selectMovie(at index: Int)
    func startRTCPeerConn()
    func giveMicPermission() //hardware permissions icin

}

enum MainScreenInteractorOutput: Equatable {
    case isConnected
}

protocol MainScreenInteractorDelegate: AnyObject {
//    func handleOutput(_ output: MainScreenInteractorOutput)
}

// MARK: - Presenter

protocol MainScreenPresenterProtocol: AnyObject {
    func routeToCallScreen()
    func getMicPermission() //hardware permissions icin
    func createRTCPeerConnection()
}

enum MainScreenPresenterOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
}

// MARK: - View

protocol MainScreenViewProtocol: AnyObject {
    func handleOutput(_ output: MainScreenPresenterOutput)

}

// MARK: - Router

enum MainScreenRoute: Equatable {
    case detail
}

protocol MainScreenRouterProtocol: AnyObject {
    func navigate(to route: MainScreenRoute)
}
