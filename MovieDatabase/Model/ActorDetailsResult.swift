import Foundation
import UIKit

public struct ActorDetailsResult: Decodable {
  let imdbId: String?

  enum CodingKeys: String, CodingKey {
    case imdbId = "imdb_id"
  }
}

