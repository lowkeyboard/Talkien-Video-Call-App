//
//
//

import AVFoundation

final class MainScreenInteractor: MainScreenInteractorProtocol {

    
    
    weak var delegate: MainScreenInteractorDelegate?
    
    func startRTCPeerConn() {
        
    }
    
    func selectMovie(at index: Int) {
//        let movie = movies[index]
//        delegate?.handleOutput(.showCallScreen(movie))
    }
    
    func giveMicPermission() {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                print("Permission granted")
//                router.navigate(to: .detail)
            case .denied:
                print("Permission denied")
            case .undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                    // Handle granted
                })
            @unknown default:
                print("Unknown case")
            }
        }

}
