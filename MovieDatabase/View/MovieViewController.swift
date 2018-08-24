import UIKit
import WebKit

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var fullTitle: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var overview: UILabel!
  @IBOutlet weak var trailer: WKWebView!
  @IBOutlet weak var castCollectionView: UICollectionView!
  @IBOutlet weak var collectionCollectionView: UICollectionView!
  @IBOutlet weak var castStackView: UIStackView!
  @IBOutlet weak var collectionStackView: UIStackView!

  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  var movie: MovieDetailsResult!
  var movieClient: MovieClient!
  var imageClient: ImageClient!
  var cast: [Actor] = []
  var collectionMovies: [Movie] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLabelText()
    setupTrailer()
    setupCredits()
    setupCollection()
  }

  func setupLabelText() {
    fullTitle.text = movie.title
    date.text = movie.date
    score.text = movie.score
    overview.text = movie.overview
  }

  func setupTrailer() {
    movieClient.getTrailer(from: .trailer(movie.id)) { [weak self] trailerKey in
      guard let key = trailerKey else {
        self?.trailer.isHidden = true
        return
      }
      guard let url = URL(string: "https://www.youtube.com/embed/\(key)") else {
        self?.trailer.isHidden = true
        return
      }
      self?.trailer.load(URLRequest(url: url))
    }
  }

  func setupCredits() {
    movieClient.getCast(from: .credits(movie.id)) { [weak self] cast in
      guard let cast = cast else {
        self?.castStackView.isHidden = true
        return
      }
      self?.cast = cast
      self?.castCollectionView.reloadData()
    }
  }

  func setupCollection() {
    guard let collectionId = movie.collection?.id else {
      collectionStackView.isHidden = true
      return
    }
    movieClient.getCollectionMovies(for: .collection(collectionId)) { [weak self] movies in
      let collectionExcludingCurrentMovie = movies.filter { $0.id != self?.movie.id }
      self?.collectionMovies = collectionExcludingCurrentMovie
      self?.collectionCollectionView.reloadData()
    }
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView == castCollectionView ? cast.count : collectionMovies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView == collectionCollectionView ? movieCellForItemAt(indexPath, forCollectionView: collectionCollectionView) : actorCellForItemAt(indexPath, forCollectionView: castCollectionView)
  }

  func movieCellForItemAt(_ indexPath: IndexPath, forCollectionView collectionView: UICollectionView) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
    cell.setupCell(movie: collectionMovies[indexPath.row], imageClient: imageClient)
    return cell
  }

  func actorCellForItemAt(_ indexPath: IndexPath, forCollectionView collectionView: UICollectionView) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath) as! ActorCollectionViewCell
    cell.setupCell(actor: cast[indexPath.row], imageClient: imageClient)
    return cell
  }
}
