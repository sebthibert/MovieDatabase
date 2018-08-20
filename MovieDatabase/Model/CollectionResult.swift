import Foundation

public struct CollectionResult: Decodable {
  let movies: [Movie]?

  enum CodingKeys: String, CodingKey {
    case movies = "parts"
  }
}

