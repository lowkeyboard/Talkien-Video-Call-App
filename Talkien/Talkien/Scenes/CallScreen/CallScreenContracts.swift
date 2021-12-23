import UIKit
import WebRTC.RTCEAGLVideoView
// MARK: - Presenter

protocol CallScreenPresenterProtocol {
    func load()
    func connectToUser()
    func endCall()
    func presentView()
}

enum CallScreenPresenterOutput: Equatable {
    case granted
    case denied
    case undetermined
}

// MARK: - View
protocol CallScreenViewProtocol: AnyObject {
    func handleOutput(_ output: CallScreenPresenterOutput)
    func getLocalView()  -> RTCCameraPreviewView
    func getRemoteView ()  -> RTCEAGLVideoView
}

// MARK: - Interactor

protocol CallScreenInteractorProtocol: AnyObject {
    var delegate: CallScreenInteractorDelegate? { get set }

    func startRTCPeerConn()
    func loadInteractor()
    func sendOffer()
    func setRemoteView(remoteView: RTCEAGLVideoView)
    func setLocalView(localView: RTCCameraPreviewView)
    func hangUp()
}

enum CallScreenInteractorOutput: Equatable {
    case isConnected
}

protocol CallScreenInteractorDelegate: AnyObject {
//    func handleOutput(_ output: CallScreenInteractorOutput)
}
