
import UIKit

final class MovieListRouter: MovieListRouterProtocol {
    
    unowned let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigate(to route: MovieListRoute) {
        switch route {
        case .detail:
            let detailView = MovieDetailBuilder.make()
            view.show(detailView, sender: nil)
        }
    }
}
