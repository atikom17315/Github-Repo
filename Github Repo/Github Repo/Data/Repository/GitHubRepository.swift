import AwaitKit
import Foundation
import Moya
import PromiseKit

protocol GitHubRepository {
  func deleteFavoriteUser(user: User) throws -> Promise<Void>
  func getFavoriteUsers() throws -> Promise<[User]>
  func getUserRepos(username: String) throws -> Promise<[Repository]>
  func getUsers() throws -> Promise<[User]>
  func saveFavoriteUser(user: User) throws -> Promise<Void>
  func searchUsers(query: String) throws -> Promise<[User]>
}

final class GitHubRepositoryImpl: GitHubRepository {
  // MARK: - Properties
  let cache: Cacheable
  let network: Networkable
  
  // MARK: - Object Life Cycle
  init(cache: Cacheable, network: Networkable) {
    self.cache = cache
    self.network = network
  }
  
  // MARK: - Methods
  func deleteFavoriteUser(user: User) throws -> Promise<Void> {
    return async { [weak self] in
      guard let self = self else { throw CacheError.unknown }
      do {
        var favoriteUsers: [User] = try await(self.cache.get(forKey: .favoriteUser)) ?? []
        if let index = favoriteUsers.firstIndex(where: { $0.id == user.id }) {
          favoriteUsers.remove(at: index)
        }
        return try await(self.cache.put(favoriteUsers, forKey: .favoriteUser))
      } catch {
        throw error
      }
    }
  }

  func getFavoriteUsers() throws -> Promise<[User]> {
    return async { [weak self] in
      guard let self = self else { throw CacheError.unknown }
      do {
        let response: [User]? = try await(self.cache.get(forKey: .favoriteUser))
        return response ?? []
      } catch {
        throw error
      }
    }
  }
  
  func getUserRepos(username: String) throws -> Promise<[Repository]> {
    return async { [weak self] in
      guard let self = self else { throw NetworkError.unknown }
      do {
        let gitHubAPI = GitHubAPI.userRepos(username: username)
        let result = try await(self.network.request(target: gitHubAPI))
        let response: [Repository] = try await(NetworkParser.parseDataResponse(result: result))
        return response
      } catch {
        throw error
      }
    }
  }

  func getUsers() throws -> Promise<[User]> {
    return async { [weak self] in
      guard let self = self else { throw NetworkError.unknown }
      do {
        if let response: [User] = try await(self.cache.get(forKey: .users)) {
          return response
        } else {
          let gitHubAPI = GitHubAPI.users
          let result = try await(self.network.request(target: gitHubAPI))
          let response: [User] = try await(NetworkParser.parseDataResponse(result: result))
          try await(self.cache.put(response, forKey: .users))
          return response
        }
      } catch {
        throw error
      }
    }
  }
  
  func saveFavoriteUser(user: User) throws -> Promise<Void> {
    return async { [weak self] in
      guard let self = self else { throw CacheError.unknown }
      do {
        var favoriteUsers: [User] = try await(self.cache.get(forKey: .favoriteUser)) ?? []
        if let index = favoriteUsers.firstIndex(where: { $0.id == user.id }) {
          favoriteUsers[index] = user
        } else {
          favoriteUsers.append(user)
        }
        return try await(self.cache.put(favoriteUsers, forKey: .favoriteUser))
      } catch {
        throw error
      }
    }
  }
  
  func searchUsers(query: String) throws -> Promise<[User]> {
    return async { [weak self] in
      guard let self = self else { throw NetworkError.unknown }
      do {
        let gitHubAPI = GitHubAPI.searchUsers(query: query)
        let result = try await(self.network.request(target: gitHubAPI))
        let response: SearchUserResponse = try await(NetworkParser.parseDataResponse(result: result))
        return response.items ?? []
      } catch {
        throw error
      }
    }
  }
}
