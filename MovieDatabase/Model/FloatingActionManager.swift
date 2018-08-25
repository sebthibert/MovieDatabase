import UIKit

protocol FloatingActionManagerDelegate: class {
  func updateColumnCount(to columnCount: CGFloat)
  func updateMovies(to sortedMovies: [MovieOverview])
}

class FloatingActionManager {
  var floatingActions: [FloatingActionView] = []
  var movies: [MovieOverview] = []
  var movieSorter: MovieSorter!
  weak var delegate: FloatingActionManagerDelegate?

  init(movies: [MovieOverview], delegate: FloatingActionManagerDelegate) {
    self.movies = movies
    self.delegate = delegate
    movieSorter = MovieSorter(movies: movies)
    setupDisplay()
    setupSortBy()
  }

  func setupDisplay() {
    let displayFloatingAction = FloatingActionView(alignment: .left)
    displayFloatingAction.buttonText = "Display"
    displayFloatingAction.addItem("Single", icon: #imageLiteral(resourceName: "single-display"), handler: displaySingleColumn)
    displayFloatingAction.addItem("Double", icon: #imageLiteral(resourceName: "dual-display"), handler: displayDoubleColumn)
    floatingActions.append(displayFloatingAction)
  }

  func displaySingleColumn() {
    delegate?.updateColumnCount(to: 1)
  }

  func displayDoubleColumn() {
    delegate?.updateColumnCount(to: 2)
  }

  func setupSortBy() {
    let sortByFloatingAction = FloatingActionView(alignment: .right)
    sortByFloatingAction.buttonText = "Sort"
    sortByFloatingAction.addItem("Rating", icon: #imageLiteral(resourceName: "star"), handler: sortByRating)
    sortByFloatingAction.addItem("Title", icon: #imageLiteral(resourceName: "abc"), handler: sortByTitle)
    sortByFloatingAction.addItem("Release date", icon: #imageLiteral(resourceName: "calendar"), handler: sortByReleaseDate)
    floatingActions.append(sortByFloatingAction)
  }

  func sortByRating() {
    delegate?.updateMovies(to: movieSorter.sortByRating())
  }

  func sortByTitle() {
    delegate?.updateMovies(to: movieSorter.sortByTitle())
  }

  func sortByReleaseDate() {
    delegate?.updateMovies(to: movieSorter.sortByReleaseDate())
  }
}
