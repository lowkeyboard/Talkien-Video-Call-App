//
//
//

import AVFoundation

final class MainScreenInteractor: NSObject,  MainScreenInteractorProtocol {
    
    func selectMovie(at index: Int) {
        print("")
        
    }
    
    weak var delegate: MainScreenInteractorDelegate?

    

    func giveMicPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Permission granted")
        case .denied:
            print("Permission denied")
        case .undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
            })
        @unknown default:
            print("Unknown case")
        }
    }
    
    func getVideoPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                // The user has previously granted access to the camera.
            print("Video Permission granted")

            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        print("video is granted.")
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        @unknown default:
            print("Unknown case")
        }
        
    }
    
    

 

}
