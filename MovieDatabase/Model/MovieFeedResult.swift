import Foundation
import UIKit

struct MovieFeedResult: Decodable {
  let results: [MovieOverview]?
}

struct MovieOverview: Decodable {
  let id: Int?
  let title: String?
  let posterPath: String?
  let overview: String?
  let backdropPath: String?
  let releaseDate: String?
  let voteAverage: Double?

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
    case overview
    case backdropPath = "backdrop_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
  }
}
