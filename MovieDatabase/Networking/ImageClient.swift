import Foundation
import UIKit

enum ImageSize {
  case medium(String?)
}

extension ImageSize: Endpoint {
  var baseURL: String {
    return "https://image.tmdb.org"
  }

  var path: String {
    switch self {
    case .medium(let posterPath): return "/t/p/w500\(posterPath ?? "")"
    }
  }
}

class ImageClient: APIClient {
  let session: URLSession

  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }

  convenience init() {
    self.init(configuration: .default)
  }

  func getImage(for imageSize: ImageSize, completion: @escaping (UIImage) -> Void) {
    let request = imageSize.request
    downloadImage(with: request, completion: completion)
  }
}
