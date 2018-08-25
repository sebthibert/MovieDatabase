import UIKit
import WebKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
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
  var cast: [ActorOverview] = []
  var collectionMovies: [MovieOverview] = []

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

  // MARK: UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView == castCollectionView ? didSelectActorCellAt(indexPath) : didSelectMovieCellAt(indexPath)
  }

  func didSelectMovieCellAt(_ indexPath: IndexPath) {

  }

  func didSelectActorCellAt(_ indexPath: IndexPath) {
    let actor = cast[indexPath.row]
    let alert = UIAlertController(title: "Visit \(actor.name ?? "") on IMDb", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
      self?.openIMDb(forActor: actor)
    })
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    present(alert, animated: true)
  }

  func openIMDb(forActor actor: ActorOverview) {
    movieClient.getActor(from: .person(actor.id)) { actor in
      guard let url = URL(string: "https://www.imdb.com/name/\(actor.imdbId ?? "")") else {
        return
      }
      UIApplication.shared.open(url)
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
