import Foundation

public struct CollectionResult: Decodable {
  let movies: [MovieOverview]?

  enum CodingKeys: String, CodingKey {
    case movies = "parts"
  }
}

