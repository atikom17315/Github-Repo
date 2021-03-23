import UIKit

final class LandingTableViewManager: NSObject, TableViewManageable {
  typealias DataType = LandingDataSection
  
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
  }
}

// MARK: - UITableViewDataSource
extension LandingTableViewManager {
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
      return tableView.dequeueReusableCell(withIndexPath: indexPath) { $0.configure(viewModel) } as UserListCell
    }
  }
}

// MARK: - UITableViewDelegate
extension LandingTableViewManager: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    let group = dataList[indexPath.section]
    let element = group.elements[indexPath.row]
    
    if case .user(let viewModel) = element {
      viewModel.input.cellSelected()
    }
  }
}
