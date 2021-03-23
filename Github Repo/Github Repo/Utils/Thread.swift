import Foundation

func main(_ execute: @escaping () -> Void) {
  DispatchQueue.main.async(execute: execute)
}

func main(with secondDelay: TimeInterval, execute: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + secondDelay, execute: execute)
}
