import UIKit

protocol FloatingActionManagerDelegate: class {
  func updateMovieFeed(to movieFeed: MovieFeed, title: String)
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
    displayFloatingAction.buttonText = "View"
    displayFloatingAction.addItem("Now playing", icon: #imageLiteral(resourceName: "clapperboard"), handler: getNowPlayingMovies)
    displayFloatingAction.addItem("Upcoming", icon: #imageLiteral(resourceName: "calendar"), handler: getUpcomingMovies)
    floatingActions.append(displayFloatingAction)
  }

  func getNowPlayingMovies() {
    delegate?.updateMovieFeed(to: .nowPlaying, title: "Now playing")
  }

  func getUpcomingMovies() {
    delegate?.updateMovieFeed(to: .upcoming, title: "Upcoming")
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
