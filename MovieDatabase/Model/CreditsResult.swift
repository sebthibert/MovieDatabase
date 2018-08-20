import Foundation

public struct CreditsResult: Decodable {
  let cast: [Actor]?
}

public struct Actor: Decodable {
  let name: String?
  let posterPath: String?

  enum CodingKeys: String, CodingKey {
    case name
    case posterPath = "profile_path"
  }
}

