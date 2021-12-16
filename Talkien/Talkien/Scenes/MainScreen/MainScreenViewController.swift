

import UIKit

final class MainScreenViewController: UIViewController, MainScreenViewProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var movies: [MoviePresentation] = []
    var presenter: MainScreenPresenterProtocol!
    
    @IBOutlet weak var JoinButton: UIButton!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var rtcpeerconnectionButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getMicPermission()
    }
    
    @IBAction func clickedButton(_ sender: Any) {
        
        presenter.routeToCallScreen()
        
    }
    
    @IBAction func clickedJoinButton(_ sender: Any) {
    }
    
    @IBAction func clickedrtcpeerbutton(_ sender: Any) {
        presenter.createRTCPeerConnection()
    }
    
    
    func handleOutput(_ output: MainScreenPresenterOutput) {
        switch output {
        case .granted:
            print("need to get user media")
        case .denied:
            print("denied.")
        case .undetermined:
            print("")
    }
}
    
    
}

