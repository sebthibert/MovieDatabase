import UIKit

class NowPlayingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  @IBAction func singleButtonPressed(_ sender: Any) {
    guard marginCount != 2 else {
      return
    }
    (marginCount, columnCount) = (2, 1)
    collectionView?.reloadData()
  }
  @IBAction func dualButtonPressed(_ sender: Any) {
    guard marginCount != 3 else {
      return
    }
    (marginCount, columnCount) = (3, 2)
    collectionView?.reloadData()
  }

  let movieClient = MovieClient()
  let imageClient = ImageClient()
  var movies: [Movie] = []
  var (marginCount, columnCount): (CGFloat, CGFloat) = (3, 2)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
  }

  func getMovies() {
    movieClient.getMovies(for: .nowPlaying) { [weak self] movies in
      self?.movies = movies
      self?.collectionView?.reloadData()
    }
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
  }


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
    let movie = movies[indexPath.row]
    imageClient.getImage(for: .medium(movie.posterPath)) { image in
      DispatchQueue.main.async {
        cell.poster.image = image
      }
    }
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NowPlayingHeader", for: indexPath)
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    movieClient.getMovie(from: .movie(movies[indexPath.row].id)) { [weak self] movie in
      self?.performSegue(withIdentifier: "ShowMovie", sender: movie)
    }
  }

  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - (10 * marginCount)) / columnCount
    return CGSize(width: width, height: width * 1.5)
  }
}

