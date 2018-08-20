import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var poster: UIImageView!

  override func prepareForReuse() {
    poster.image = nil
  }
}

