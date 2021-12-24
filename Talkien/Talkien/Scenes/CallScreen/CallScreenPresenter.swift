import WebRTC

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
    
    func _startCaptureLocalVideo(renderer: RTCVideoRenderer) {
        
        interactor.startCaptureLocalVideo(renderer: renderer)
        
    }
    
    
    func _renderRemoteVideo(to renderer: RTCVideoRenderer) {
        interactor.startCaptureLocalVideo(renderer: renderer)
    }

    
}
