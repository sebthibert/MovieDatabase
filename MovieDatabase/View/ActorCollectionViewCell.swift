import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var name: UILabel!

  func setupCell(actor: Actor, imageClient: ImageClient) {
    imageClient.getImage(for: actor.posterPath) { [weak self] image in
      DispatchQueue.main.async {
        self?.poster.image = image
      }
    }
    name.text = actor.name
  }

  override func prepareForReuse() {
    poster.image = nil
    name.text = nil
  }
}

