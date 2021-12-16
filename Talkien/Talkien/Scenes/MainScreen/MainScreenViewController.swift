

import UIKit

final class MainScreenViewController: UIViewController, MainScreenViewProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var movies: [MoviePresentation] = []
    var presenter: MainScreenPresenterProtocol!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getMicPermission()
    }
    
    @IBAction func clickedButton(_ sender: Any) {
        
        presenter.routeToCallScreen()

    }
    
    
    
    
    func handleOutput(_ output: MainScreenPresenterOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}
    
    
}

