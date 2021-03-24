import UIKit

class UserRepositoryTableViewManager: NSObject, TableViewManageable {
  typealias DataType = UserRepositoryDataSection
  
  // MARK: - Properties
  private let tableView: UITableView
  var dataList: [DataType] = [] {
    didSet { tableView.reloadData() }
  }
  
  required init(tableView: UITableView) {
    self.tableView = tableView
    super.init()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 96.0
    tableView.backgroundColor = .clear
    
    tableView.registerReusableCell(LoadingListCell.self)
    tableView.registerReusableCell(UserListCell.self)
    tableView.registerReusableCell(UserRepositoryListCell.self)
  }
}

// MARK: - UITableViewDataSource
extension UserRepositoryTableViewManager: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList[section].elements.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group = dataList[indexPath.section]
    let element = group.elements[indexPath.row]
    
    switch element {
    case .loading:
      return tableView.dequeueReusableCell(withIndexPath: indexPath) as LoadingListCell
    case .user(let viewModel):
      let cell = tableView.dequeueReusableCell(withIndexPath: indexPath) { $0.configure(viewModel) } as UserListCell
      cell.selectionStyle = .none
      return cell
    case .userRepository(let viewModel):
      let cell = tableView.dequeueReusableCell(withIndexPath: indexPath) { $0.configure(viewModel) } as UserRepositoryListCell
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension UserRepositoryTableViewManager: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    let group = dataList[indexPath.section]
    let element = group.elements[indexPath.row]
    
    if case .userRepository(let viewModel) = element {
      viewModel.input.cellSelected()
    }
  }
}
