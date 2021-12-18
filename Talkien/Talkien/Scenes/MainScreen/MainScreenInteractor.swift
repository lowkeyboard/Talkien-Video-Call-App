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
    
    

 

}
