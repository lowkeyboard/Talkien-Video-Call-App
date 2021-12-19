

import UIKit

final class CallScreenViewController: UIViewController, CallScreenViewProtocol {
    
    
    
    @IBOutlet weak var ExitCallButton: UIButton!
    @IBOutlet weak var SendOfferButton: UIButton!
    
    var presenter: CallScreenPresenterProtocol!
    
    let vc = BottomSheetViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load() 
    }

    func handleOutput(_ output: CallScreenPresenterOutput) {
        
    }
    
    //rename as  joincall
    @IBAction func ExitCallPressed(_ sender: Any) {
        presenter.endCall()
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SendOfferPressed(_ sender: Any) {
        presenter.connectToUser()
        
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
            
            }
        } else {
            // Fallback on earlier versions
        }
        
        self.present(vc, animated: true, completion: nil)

    }
    
}
