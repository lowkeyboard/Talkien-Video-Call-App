

protocol CallScreenPresenterProtocol {
    func load()
}

protocol CallScreenViewProtocol: class {

}

protocol CallScreenInteractorProtocol: AnyObject {
    var delegate: CallScreenInteractorDelegate? { get set }

    
    //bunlar diger sayfanin interactoru olcak.
    func startRTCPeerConn()
    func loadInteractor()
    func makeOffer()
}

enum CallScreenInteractorOutput: Equatable {
    case isConnected
}

protocol CallScreenInteractorDelegate: AnyObject {
//    func handleOutput(_ output: CallScreenInteractorOutput)
}
