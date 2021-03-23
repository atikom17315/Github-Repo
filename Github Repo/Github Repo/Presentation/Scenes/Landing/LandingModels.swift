import Foundation

enum Landing {
  enum Content {
    struct Response {
      let users: [User]
    }
    struct ViewModel {
      let dataList: [LandingDataSection]
    }
  }
  enum FavoriteUser {
    struct Request {
      let isShowFavoriteUser: Bool
    }
  }
  enum Loading {
    struct Response {
      let isShow: Bool
    }
    typealias ViewModel = Response
  }
  enum SearchUser {
    struct Request {
      let query: String
    }
  }
  enum UserSelected {
    struct Request {
      let user: User
    }
    typealias ViewModel = Request
  }
}
