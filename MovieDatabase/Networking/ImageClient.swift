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
  let cache = NSCache<NSString, UIImage>()

  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
    cache.countLimit = 100
  }

  convenience init() {
    self.init(configuration: .default)
  }

  func getImage(for posterPath: String?, completion: @escaping (UIImage) -> Void) {
    guard let posterPath = posterPath else {
      completion(#imageLiteral(resourceName: "cast-placeholder"))
      return
    }
    guard let cachedImage = cache.object(forKey: NSString(string: posterPath)) else {
      downloadImage(for: .medium(posterPath)) { [weak self] image in
        self?.cache.setObject(image, forKey: NSString(string: posterPath))
        completion(image)
      }
      return
    }
    completion(cachedImage)
  }

  func downloadImage(for imageSize: ImageSize, completion: @escaping (UIImage) -> Void) {
    let request = imageSize.request
    fetchImage(with: request, completion: completion)
  }
}
