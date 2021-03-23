import UIKit

protocol Reusable: class {
  static var reuseIdentifier: String { get }
  static var nib: UINib { get }
  
  func setupUI()
  func addObserver()
  func removeObserver()
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
  
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
  
  func setupUI() { }
  func addObserver() { }
  func removeObserver() { }
}

extension Reusable where Self: UIView {
  static func loadFromNib(execute: ((Self) -> Void)) -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("The nib \(nib) expected its root view to be of type \(self)")
    }
    execute(view)
    view.setupUI()
    return view
  }
}
