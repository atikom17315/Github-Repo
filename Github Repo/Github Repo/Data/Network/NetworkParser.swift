import Foundation
import Moya
import PromiseKit

final class NetworkParser {
  class func parseDataResponse <T: Decodable> (result: Moya.Response) throws -> Promise<T> {
    return Promise { seal in
      do {
        let jsonDecoder = JSONDecoder()
        let responseMapper: T = try jsonDecoder.decode(T.self, from: result.data)
        seal.fulfill(responseMapper)
      } catch {
        throw NetworkError.parseData
      }
    }
  }
}
