
import UIKit

final class CallScreenBuilder {
    
    static func make() -> CallScreenViewController {
        let storyboard = UIStoryboard(name: "CallScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CallScreenViewController") as! CallScreenViewController
        let interactor = CallScreenInteractor()

        let presenter = CallScreenPresenter(view: viewController, interactor: interactor)
        viewController.presenter = presenter
        return viewController
    }
}
