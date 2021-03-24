import Foundation
import Moya
import PromiseKit

class NetworkParser {
  class func parseDataResponse <T: Decodable> (data: Data) -> T? {
    do {
      let jsonDecoder = JSONDecoder()
      let responseMapper: T? = try jsonDecoder.decode(T.self, from: data)
      return responseMapper
    } catch {
      return nil
    }
  }
  
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
