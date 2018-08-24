import Foundation
import UIKit

enum APIError: Error {
  case requestFailed
  case jsonConversionFailure
  case invalidData
  case responseUnsuccessful
  case jsonParsingFailure

  var localizedDescription: String {
    switch self {
    case .requestFailed: return "Request Failed"
    case .invalidData: return "Invalid Data"
    case .responseUnsuccessful: return "Response Unsuccessful"
    case .jsonParsingFailure: return "JSON Parsing Failure"
    case .jsonConversionFailure: return "JSON Conversion Failure"
    }
  }
}

protocol APIClient {
  var session: URLSession { get }
}

extension APIClient {
  func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping (Decodable?, APIError?) -> Void) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(nil, .requestFailed)
        return
      }
      if httpResponse.statusCode == 200 {
        if let data = data {
          do {
            let json = try JSONDecoder().decode(decodingType, from: data)
            completion(json, nil)
          } catch {
            completion(nil, .jsonConversionFailure)
          }
        } else {
          completion(nil, .invalidData)
        }
      } else {
        completion(nil, .responseUnsuccessful)
      }
    }
    return task
  }

  func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
    let task = decodingTask(with: request, decodingType: T.self) { json , error in
      DispatchQueue.main.async {
        guard let json = json else {
          if let error = error {
            completion(.failure(error))
          } else {
            completion(.failure(.invalidData))
          }
          return
        }
        if let value = decode(json) {
          completion(.success(value))
        } else {
          completion(.failure(.jsonParsingFailure))
        }
      }
    }
    task.resume()
  }

  func fetchImage(with request: URLRequest, completion: @escaping (UIImage) -> Void) {
    let task = session.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        guard let data = data else {
          return
        }
        guard let image = UIImage(data: data) else {
          return
        }
        completion(image)
      }
    }
    task.resume()
  }
}
