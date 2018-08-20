import Foundation

protocol Endpoint {
  var baseURL: String { get }
  var path: String { get }
}

extension Endpoint {

  var apiKey: String {
    return "api_key=f7caebd7ef3ee2bd2ca8ecfc1cb67a2c"
  }

  var urlComponents: URLComponents {
    var components = URLComponents(string: baseURL)!
    components.path = path
    components.query = apiKey
    return components
  }

  var request: URLRequest {
    let url = urlComponents.url!
    return URLRequest(url: url)
  }
}
