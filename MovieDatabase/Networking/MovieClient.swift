import Foundation

enum MovieFeed {
  case nowPlaying
  case movie(Int?)
  case trailer(Int?)
  case credits(Int?)
  case collection(Int?)
}

extension MovieFeed: Endpoint {
  var baseURL: String {
    return "https://api.themoviedb.org"
  }

  var path: String {
    switch self {
    case .nowPlaying: return "/3/movie/now_playing"
    case .movie(let id): return "/3/movie/\(id ?? 0)"
    case .trailer(let id): return "/3/movie/\(id ?? 0)/videos"
    case .credits(let id): return "/3/movie/\(id ?? 0)/credits"
    case .collection(let id): return "/3/collection/\(id ?? 0)"
    }
  }
}

class MovieClient: APIClient {
  let session: URLSession

  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }

  convenience init() {
    self.init(configuration: .default)
  }

  func getMovies(for movieFeedType: MovieFeed, completion: @escaping ([MovieOverview]) -> Void) {
    getMovieFeedResult(for: movieFeedType) { result in
      switch result {
      case .success(let movieFeedResult):
        guard let movies = movieFeedResult?.results else {
          return
        }
        completion(movies)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getMovieFeedResult(for movieFeedType: MovieFeed, completion: @escaping (Result<MovieFeedResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> MovieFeedResult? in
      guard let movieFeedResult = json as? MovieFeedResult else {
        return  nil
      }
      return movieFeedResult
    }, completion: completion)
  }

  func getMovie(from movieFeedType: MovieFeed, completion: @escaping (MovieDetailsResult) -> Void) {
    getMovieDetailsResult(from: movieFeedType) { result in
      switch result {
      case .success(let movieDetailsResult):
        guard let movie = movieDetailsResult else {
          return
        }
        completion(movie)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getMovieDetailsResult(from movieFeedType: MovieFeed, completion: @escaping (Result<MovieDetailsResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> MovieDetailsResult? in
      guard let movieDetails = json as? MovieDetailsResult else {
        return nil
      }
      return movieDetails
    }, completion: completion)
  }

  func getTrailer(from movieFeedType: MovieFeed, completion: @escaping (String?) -> Void) {
    getTrailerResult(from: movieFeedType) { result in
      switch result {
      case .success(let trailerResult):
        completion(trailerResult?.results?.first?.key)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getTrailerResult(from movieFeedType: MovieFeed, completion: @escaping (Result<TrailerResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> TrailerResult? in
      guard let trailerResult = json as? TrailerResult else {
        return nil
      }
      return trailerResult
    }, completion: completion)
  }

  func getCast(from movieFeedType: MovieFeed, completion: @escaping ([ActorOverview]?) -> Void) {
    getCreditsResult(from: movieFeedType) { result in
      switch result {
      case .success(let creditsResult):
        completion(creditsResult?.cast)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getCreditsResult(from movieFeedType: MovieFeed, completion: @escaping (Result<CreditsResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> CreditsResult? in
      guard let creditsResult = json as? CreditsResult else {
        return nil
      }
      return creditsResult
    }, completion: completion)
  }

  func getActor(from movieFeedType: MovieFeed, completion: @escaping (ActorDetailsResult) -> Void) {
    getActorDetailsResult(from: movieFeedType) { result in
      switch result {
      case .success(let actorResult):
        guard let actorResult = actorResult else {
          return
        }
        completion(actorResult)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getActorDetailsResult(from movieFeedType: MovieFeed, completion: @escaping (Result<ActorDetailsResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> ActorDetailsResult? in
      guard let actorDetails = json as? ActorDetailsResult else {
        return nil
      }
      return actorDetails
    }, completion: completion)
  }

  func getCollectionMovies(for movieFeedType: MovieFeed, completion: @escaping ([MovieOverview]) -> Void) {
    getCollectionResult(from: movieFeedType) { result in
      switch result {
      case .success(let collectionResult):
        guard let movies = collectionResult?.movies else {
          return
        }
        completion(movies)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getCollectionResult(from movieFeedType: MovieFeed, completion: @escaping (Result<CollectionResult?, APIError>) -> Void) {
    let request = movieFeedType.request
    fetch(with: request, decode: { json -> CollectionResult? in
      guard let collectionResult = json as? CollectionResult else {
        return nil
      }
      return collectionResult
    }, completion: completion)
  }
}
