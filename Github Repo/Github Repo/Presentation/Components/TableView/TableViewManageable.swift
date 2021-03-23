import UIKit

protocol TableViewManageable: UITableViewDataSource, UITableViewDelegate {
    associatedtype DataType
    var dataList: [DataType] { get set }
    init(tableView: UITableView)
}
