import Foundation

public struct TrailerResult: Decodable {
  let results: [Trailer]?
}

public struct Trailer: Decodable {
  let key: String?
}
