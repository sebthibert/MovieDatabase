import UIKit

class NowPlayingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
  @IBOutlet weak var collectionView: UICollectionView!
  let movieClient = MovieClient()
  let imageClient = ImageClient()
  var movies: [Movie] = []
  var movieSelectedIndex = IndexPath(item: 0, section: 0)

  var movieSelectedFrame: CGRect {
    let cellFrame = collectionView?.layoutAttributesForItem(at: movieSelectedIndex)?.frame ?? .zero
    return collectionView?.convert(cellFrame, to: collectionView?.superview) ?? .zero
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
    setupFloatingAction()
  }

  func getMovies() {
    movieClient.getMovies(for: .nowPlaying) { [weak self] movies in
      self?.movies = movies
      self?.collectionView?.reloadData()
    }
  }

  func setupFloatingAction() {
    let sortByFloatingAction = FloatingActionView()
    sortByFloatingAction.buttonText = "Sort"
    sortByFloatingAction.addItem("Rating", icon: #imageLiteral(resourceName: "star"), handler: sortByRating)
    sortByFloatingAction.addItem("Title", icon: #imageLiteral(resourceName: "abc"), handler: sortByTitle)
    sortByFloatingAction.addItem("Release date", icon: #imageLiteral(resourceName: "calendar"), handler: sortByReleaseDate)
    view.addSubview(sortByFloatingAction)
  }

  func sortByRating() {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsVoteAverage = lhs.voteAverage, let rhsVoteAverage = rhs.voteAverage else {
        return false
      }
      return lhsVoteAverage > rhsVoteAverage
    }
    collectionView.reloadData()
  }

  func sortByTitle() {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsTitle = lhs.title, let rhsTitle = rhs.title else {
        return false
      }
      return lhsTitle < rhsTitle
    }
    collectionView.reloadData()
  }

  func sortByReleaseDate() {
    movies.sort { lhs, rhs -> Bool in
      guard let lhsDate = lhs.releaseDate, let rhsDate = rhs.releaseDate else {
        return false
      }
      return lhsDate > rhsDate
    }
    collectionView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let movie = sender as? MovieDetailsResult else {
      return
    }
    guard let viewController = segue.destination as? MovieViewController else {
      return
    }
    viewController.movie = movie
    viewController.movieClient = movieClient
    viewController.imageClient = imageClient
    viewController.transitioningDelegate = self
  }

  // MARK: UICollectionViewDatasource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
    cell.setupCell(movie: movies[indexPath.row], imageClient: imageClient)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NowPlayingHeader", for: indexPath)
  }

  // MARK: UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.allowsSelection = false
    movieSelectedIndex = indexPath
    movieClient.getMovie(from: .movie(movies[indexPath.row].id)) { [weak self] movie in
      self?.performSegue(withIdentifier: "ShowMovie", sender: movie)
      collectionView.allowsSelection = true
    }
  }

  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 30) / 2
    return CGSize(width: width, height: width * 1.5)
  }

  // MARK: UIViewControllerTransitioningDelegate

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ExpandAnimationController(originFrame: movieSelectedFrame)
  }
}
