
final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    unowned var view: MovieDetailViewProtocol
    
    init(view: MovieDetailViewProtocol) {
        self.view = view
    }
    
    func load() {
        //deleted: view.update()
    }
}
