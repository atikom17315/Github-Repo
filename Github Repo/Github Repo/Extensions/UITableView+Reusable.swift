import UIKit

extension UITableView {
  func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
    self.register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(withIndexPath indexPath: IndexPath, execute: ((T) -> Void)? = nil) -> T where T: Reusable {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Please check identifier!")
    }
    execute?(cell)
    cell.setupUI()
    return cell
  }
}
