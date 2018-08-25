import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var poster: UIImageView!

  func setupCell(movie: MovieOverview, imageClient: ImageClient) {
    imageClient.getImage(for: movie.posterPath) { [weak self] image in
      DispatchQueue.main.async {
        self?.poster.image = image
      }
    }
  }

  override func prepareForReuse() {
    poster.image = nil
  }
}

