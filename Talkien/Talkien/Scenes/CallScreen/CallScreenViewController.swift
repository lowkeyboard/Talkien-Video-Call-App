

import UIKit

final class CallScreenViewController: UIViewController, CallScreenViewProtocol {
    
    var presenter: CallScreenPresenterProtocol!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load()
    }
    
}
