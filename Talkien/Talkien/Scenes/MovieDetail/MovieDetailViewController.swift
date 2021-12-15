

import UIKit

final class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    var presenter: MovieDetailPresenterProtocol!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load()
    }
    
}
