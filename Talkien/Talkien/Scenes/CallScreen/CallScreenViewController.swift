

import UIKit

final class CallScreenViewController: UIViewController, CallScreenViewProtocol {
    
    var presenter: CallScreenPresenterProtocol!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load()
    }
    
}
