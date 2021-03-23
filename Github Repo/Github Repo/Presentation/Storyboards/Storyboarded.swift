import UIKit

protocol Storyboarded {
  static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
  static func instantiate() -> Self {
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
      fatalError("The storyboard doesn't contain a view controller with identifier `\(className)`")
    }
    return viewController
  }
}
