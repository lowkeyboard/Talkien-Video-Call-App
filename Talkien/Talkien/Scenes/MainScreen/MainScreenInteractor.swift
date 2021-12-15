//
//
//



final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    weak var delegate: MainScreenInteractorDelegate?
    

    
    func load() {
        delegate?.handleOutput(.setLoading(true))

    }
    
    func selectMovie(at index: Int) {
//        let movie = movies[index]
//        delegate?.handleOutput(.showCallScreen(movie))
    }
}
