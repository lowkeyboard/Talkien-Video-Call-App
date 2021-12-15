
import UIKit

final class MovieDetailBuilder {
    
    static func make() -> MovieDetailViewController {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let presenter = MovieDetailPresenter(view: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
