import AwaitKit
import Foundation
import Moya
import PromiseKit

final class NetworkManager: Networkable {
  // MARK: - Typealias or Enum
  enum Environment {
    case local
    case server
    case test
    
    func stubClosure(for target: TargetType) -> Moya.StubBehavior {
      switch self {
      case .local: return .delayed(seconds: 1.0)
      case .server: return .never
      case .test: return .immediate
      }
    }
  }
  
  // MARK: - Properties
  private let environment: Environment
  private lazy var plugins: [PluginType] = {
    return [
      NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))
    ]
  }()
  
  // MARK: - Object Life Cycle
  init(environment: Environment = .server) {
    self.environment = environment
  }
  
  // MARK: - Methods
  func request<Target: TargetType>(target: Target) throws -> Promise<Moya.Response> {
    return async {
      let (moyaResponse, moyaError) = try await(self.call(target: target))
      if let response = moyaResponse {
        return response
      } else if let moyaError = moyaError, case let .underlying(_ as NSError, response) = moyaError {
        // We can handle the error ex. TimedOut, NetworkConnectionLost, HttpError, etc.
        guard let response = response, response.statusCode == 422 else { throw NetworkError.unknown }
        throw NetworkError.permission
      } else {
        throw NetworkError.unknown
      }
    }
  }
}

// MARK: - Helpers
extension NetworkManager {
  private func createMoyaProvider<Target: TargetType>(target: Target) -> MoyaProvider<Target> {
    #if DEBUG
    return MoyaProvider<Target>(stubClosure: environment.stubClosure)
    #else
    return MoyaProvider<Target>(stubClosure: environment.stubClosure)
    #endif
  }
  
  private func call<Target: TargetType>(target: Target) -> Promise<(Moya.Response?, MoyaError?)> {
    return Promise { [weak self] seal in
      guard let self = self else { return }
      
      let provider = self.createMoyaProvider(target: target)
      provider.request(target) { result in
        switch result {
        case .success(let response):
          seal.fulfill((response, nil))
        case .failure(let moyaError):
          seal.fulfill((nil, moyaError))
        }
      }
    }
  }
  
  private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
      return String(data: data, encoding: .utf8) ?? ""
    }
  }
}
