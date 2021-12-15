

import UIKit

final class MovieListViewController: UIViewController, MovieListViewProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var movies: [MoviePresentation] = []
    var presenter: MovieListPresenterProtocol!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.load()
    }
    
    @IBAction func clickedButton(_ sender: Any) {
        
        presenter.selectMovie(at: 0)

    }
    
    
    
    
    func handleOutput(_ output: MovieListPresenterOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}
    
    
}

