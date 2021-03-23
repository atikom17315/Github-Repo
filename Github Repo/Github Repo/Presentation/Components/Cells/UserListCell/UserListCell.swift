import Kingfisher
import UIKit

class UserListCell: UITableViewCell, Reusable {
  // MARK: - Properties
  private var viewModel: UserListInteractorIO!
  
  // MARK: - IBOutlet
  @IBOutlet private var imageProfile: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var favoriteButton: UIButton!
  
  // MARK: - Configure
  func configure(_ viewModel: UserListInteractorIO) {
    self.viewModel = viewModel
  }
  
  // MARK: - Methods
  func setupUI() {
    selectionStyle = .gray
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    bindToViewModel()
  }
  
  @IBAction private func pressButton(_ sender: Any) {
    viewModel.input.favoriteSelected()
  }
}

// MARK: - Binding
extension UserListCell {
  func bindToViewModel() {
    viewModel.output.isFavorite.observe { [weak self] (result) in
      guard let self = self else { return }
      self.favoriteButton.isSelected = result
    }
    viewModel.output.githubUrl.observe { [weak self] (result) in
      guard let self = self else { return }
      self.descriptionLabel.text = result
    }
    viewModel.output.imageUrl.observe { [weak self] (result) in
      guard let self = self else { return }
      let url = URL(string: result)
      self.imageProfile.kf.setImage(with: url)
    }
    viewModel.output.username.observe { [weak self] (result) in
      guard let self = self else { return }
      self.titleLabel.text = result
    }
  }
}
