
import UIKit

final class MainScreenBuilder {
    
    static func make() -> MainScreenViewController {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        let router = MainScreenRouter(view: view)
//        let interactor = MainScreenInteractor(service: app.service)
        let presenter = MainScreenPresenter(view: view,
//                                           interactor: interactor,
                                           router: router)
        view.presenter = presenter
        return view
    }
    
    
}
