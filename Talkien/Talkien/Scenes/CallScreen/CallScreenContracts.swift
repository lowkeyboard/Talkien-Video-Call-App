import UIKit
import WebRTC.RTCEAGLVideoView
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
    func embedView(_ view: UIView, into containerView: UIView)
}

// MARK: - Interactor

protocol CallScreenInteractorProtocol: AnyObject {
    var delegate: CallScreenInteractorDelegate? { get set }

    func startRTCPeerConn()
    func loadInteractor()
    func sendOffer()
    func hangUp()
    
    func webRTCClient(_ client: CallScreenInteractor, didDiscoverLocalCandidate candidate: RTCIceCandidate)
    func webRTCClient(_ client: CallScreenInteractor, didChangeConnectionState state: RTCIceConnectionState)
    func webRTCClient(_ client: CallScreenInteractor, didReceiveData data: Data)

}

enum CallScreenInteractorOutput: Equatable {
    case isConnected
}

protocol CallScreenInteractorDelegate: AnyObject {
//    func handleOutput(_ output: CallScreenInteractorOutput)
}
