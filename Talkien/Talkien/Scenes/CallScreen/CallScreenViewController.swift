

import UIKit

final class CallScreenViewController: UIViewController, CallScreenViewProtocol {
    
    
    
    
    
    @IBOutlet weak var ExitCallButton: UIButton!
    
    @IBOutlet weak var SendOfferButton: UIButton!
    
    var presenter: CallScreenPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load() 
    }

    func handleOutput(_ output: CallScreenPresenterOutput) {
        
    }
    
    @IBAction func ExitCallPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func SendOfferPressed(_ sender: Any) {
        presenter.connectToUser()
        print("lol")

    }
    
    
    
    
    
    
    
    
    
}
