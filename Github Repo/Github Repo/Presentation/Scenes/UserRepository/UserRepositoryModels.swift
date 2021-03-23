import Foundation

enum UserRepository {
  enum Content {
    struct Response {
      let user: User
      let repos: [Repository]
    }
    struct ViewModel {
      let dataList: [UserRepositoryDataSection]
    }
  }
  enum Loading {
    struct Response {
      let isShow: Bool
    }
    typealias ViewModel = Response
  }
}
