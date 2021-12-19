

import UIKit

final class MainScreenViewController: UIViewController, MainScreenViewProtocol {

    
        
//    private var movies: [MoviePresentation] = []
    var presenter: MainScreenPresenterProtocol!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        presenter.getMicPermission()
    }
    
    // Call Button.
    @IBAction func clickedButton(_ sender: Any) {
        guard let channelName = textField.text, let name = nameText.text, !channelName.isEmpty, !name.isEmpty else {
            let alert = UIAlertController(title: "False Input!", message: "Please type a room name to join.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))

            DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
            }
            return

        }
        
            NameProvider.sharedInstance.channel_name = textField.text!
            NameProvider.sharedInstance.user_name = nameText.text!
        
            presenter.routeToCallScreen()

        
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


