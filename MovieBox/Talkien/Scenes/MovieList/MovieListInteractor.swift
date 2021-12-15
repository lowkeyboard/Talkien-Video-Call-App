

final class MovieListInteractor: MovieListInteractorProtocol {
    
    weak var delegate: MovieListInteractorDelegate?
    
    
    
    func load() {
        delegate?.handleOutput(.setLoading(true))

    }
    
    func selectMovie(at index: Int) {
//        let movie = movies[index]
//        delegate?.handleOutput(.showMovieDetail(movie))
    }
}
