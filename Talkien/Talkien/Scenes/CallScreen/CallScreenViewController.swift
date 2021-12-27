

import UIKit
import WebRTC

final class CallScreenViewController: UIViewController, CallScreenViewProtocol {

    
    
    
    @IBOutlet weak var localVideoView: UIView!
    
    @IBOutlet weak var TheChannelName: UILabel!
    
    @IBOutlet weak var ExitCallButton: UIButton!
    @IBOutlet weak var SendOfferButton: UIButton!
    
    var presenter: CallScreenPresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        TheChannelName.text = "Channel: \(NameProvider.sharedInstance.channel_name)"
        presenter.load()

    }
    
    
     func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }

    
    

    func handleOutput(_ output: CallScreenPresenterOutput) {
        
    }
    
    //rename as  joincall
    @IBAction func ExitCallPressed(_ sender: Any) {
        presenter.endCall()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func SendOfferPressed(_ sender: Any) {
        presenter.connectToUser()
        
        #if arch(arm64)
            // Using metal (arm64 only)
            let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
            localRenderer.videoContentMode = .scaleAspectFill
            remoteRenderer.videoContentMode = .scaleAspectFill
        #else
            // Using OpenGLES for the rest
            let localRenderer = RTCEAGLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif

//        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
//        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
  
        presenter._startCaptureLocalVideo(renderer: localRenderer)
        presenter._renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.view)
        self.view.sendSubviewToBack(remoteRenderer)
    }
    
    
}
    
