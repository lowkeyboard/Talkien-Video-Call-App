
// MARK: - Presenter

protocol CallScreenPresenterProtocol {
    func load()
    func connectToUser()
    func endCall()
}

enum CallScreenPresenterOutput: Equatable {
    case granted
    case denied
    case undetermined
}

// MARK: - View
protocol CallScreenViewProtocol: AnyObject {
    func handleOutput(_ output: CallScreenPresenterOutput)

}

// MARK: - Interactor

protocol CallScreenInteractorProtocol: AnyObject {
    var delegate: CallScreenInteractorDelegate? { get set }

    
    //bunlar diger sayfanin interactoru olcak.
    func startRTCPeerConn()
    func loadInteractor()
    func sendOffer()
    func hangUp()
}

enum CallScreenInteractorOutput: Equatable {
    case isConnected
}

protocol CallScreenInteractorDelegate: AnyObject {
//    func handleOutput(_ output: CallScreenInteractorOutput)
}
