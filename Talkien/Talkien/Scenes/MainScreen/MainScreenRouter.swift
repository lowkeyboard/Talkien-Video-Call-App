
import UIKit

final class MainScreenRouter: MainScreenRouterProtocol {
    
    unowned let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigate(to route: MainScreenRoute) {
        switch route {
        case .detail:
            let detailView = CallScreenBuilder.make()
            view.show(detailView, sender: nil)
        }
    }
}
