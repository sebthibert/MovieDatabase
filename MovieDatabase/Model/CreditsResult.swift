import Foundation

public struct CreditsResult: Decodable {
  let cast: [ActorOverview]?
}

public struct ActorOverview: Decodable {
  let id: Int?
  let name: String?
  let posterPath: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case posterPath = "profile_path"
  }
}

