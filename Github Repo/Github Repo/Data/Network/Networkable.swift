import Foundation
import Moya
import PromiseKit

protocol Networkable {
  func request<Target: TargetType>(target: Target) throws -> Promise<Moya.Response>
}
