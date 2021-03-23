import Kingfisher
import UIKit

class UserRepositoryListCell: UITableViewCell, Reusable {
  // MARK: - Properties
  private var viewModel: UserRepositoryListInteractorIO!
  
  // MARK: - IBOutlet
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  
  // MARK: - Configure
  func configure(_ viewModel: UserRepositoryListInteractorIO) {
    self.viewModel = viewModel
  }
  
  // MARK: - Methods
  func setupUI() {
    selectionStyle = .gray
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    bindToViewModel()
  }
}

// MARK: - Binding
extension UserRepositoryListCell {
  func bindToViewModel() {
    viewModel.output.name.observe { [weak self] (result) in
      guard let self = self else { return }
      self.titleLabel.text = result
    }
    viewModel.output.description.observe { [weak self] (result) in
      guard let self = self else { return }
      self.descriptionLabel.text = result
      self.descriptionLabel.isHidden = result.trim().isEmpty
    }
    viewModel.output.openURL.observe { [weak self] (result) in
      guard let url = URL(string: result), self != nil else { return }
      UIApplication.shared.open(url)
    }
  }
}
