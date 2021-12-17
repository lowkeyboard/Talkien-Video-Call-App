
// MARK: - Interactor

protocol MainScreenInteractorProtocol: AnyObject {
    var delegate: MainScreenInteractorDelegate? { get set }
    func selectMovie(at index: Int)
    func giveMicPermission() //hardware permissions icin
    
    //bunlar diger sayfanin interactoru olcak.
    func startRTCPeerConn()
    func loadInteractor()
    func makeOffer()
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
    
    //diger sayfa
    func createRTCPeerConnection()
}

enum MainScreenPresenterOutput: Equatable {
    case granted
    case denied
    case undetermined
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
