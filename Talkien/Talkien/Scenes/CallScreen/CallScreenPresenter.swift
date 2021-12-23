
final class CallScreenPresenter: CallScreenPresenterProtocol, CallScreenInteractorDelegate {

    
    
    unowned var view: CallScreenViewProtocol
    private let interactor: CallScreenInteractorProtocol

    init(view: CallScreenViewProtocol, interactor: CallScreenInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        
        self.interactor.delegate = self
    }
    
    func load() {
        interactor.loadInteractor()
    }
    
    //add another button to view for this utility.
    func connectToUser() {
        interactor.sendOffer()
    }
    
    func endCall() {
        interactor.hangUp()
    }

    func presentView() {
        interactor.setLocalView(localView: view.getLocalView())
        interactor.setRemoteView(remoteView: view.getRemoteView())
    }
    
}
