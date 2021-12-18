

import UIKit
import CallKit

final class MainScreenViewController: UIViewController, MainScreenViewProtocol {

    
        
    private var movies: [MoviePresentation] = []
    var presenter: MainScreenPresenterProtocol!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var rtcpeerconnectionButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getMicPermission()
    }
    
    // Call Button.
    @IBAction func clickedButton(_ sender: Any) {
            presenter.routeToCallScreen()
//        } else {
//            let alert = UIAlertController(title: "False Input!", message: "Please type a room name to join.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: NSLocalizedString("Accept", comment: "Default action"), style: .default, handler: { _ in
//            }))
//
//            DispatchQueue.main.async{
//            self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    

    
    
    // mikrofon permission
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

