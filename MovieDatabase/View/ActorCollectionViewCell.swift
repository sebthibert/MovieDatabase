import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var name: UILabel!

  override func prepareForReuse() {
    poster.image = nil
    name.text = nil
  }
}

