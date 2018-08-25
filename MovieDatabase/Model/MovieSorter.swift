import Foundation

class MovieSorter {
  var movies: [MovieOverview] = []

  init(movies: [MovieOverview]) {
    self.movies = movies
  }

  func sortByRating() -> [MovieOverview] {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsVoteAverage = lhs.voteAverage, let rhsVoteAverage = rhs.voteAverage else {
        return false
      }
      return lhsVoteAverage > rhsVoteAverage
    }
    return movies
  }

  func sortByTitle() -> [MovieOverview] {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsTitle = lhs.title, let rhsTitle = rhs.title else {
        return false
      }
      return lhsTitle < rhsTitle
    }
    return movies
  }

  func sortByReleaseDate() -> [MovieOverview] {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsDate = lhs.releaseDate, let rhsDate = rhs.releaseDate else {
        return false
      }
      return lhsDate > rhsDate
    }
    return movies
  }
}
