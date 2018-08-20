import Foundation

protocol Endpoint {
  var baseURL: String { get }
  var path: String { get }
}

extension Endpoint {

  var region: URLQueryItem {
    return URLQueryItem(name: "region", value: "GB")
  }

  var apiKey: URLQueryItem {
    return URLQueryItem(name: "api_key", value: "f7caebd7ef3ee2bd2ca8ecfc1cb67a2c")
  }

  var urlComponents: URLComponents {
    var components = URLComponents(string: baseURL)!
    components.path = path
    components.queryItems = [apiKey, region]
    return components
  }

  var request: URLRequest {
    let url = urlComponents.url!
    return URLRequest(url: url)
  }
}
