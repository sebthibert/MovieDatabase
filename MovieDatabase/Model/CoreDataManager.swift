import CoreData
import UIKit

class CoreDataManager {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let managedContext: NSManagedObjectContext!
  let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
  var movies: [NSManagedObject] = []

  init() {
    self.managedContext = appDelegate.persistentContainer.viewContext
  }

  func saveMovie(_ movie: MovieOverview) {
    guard !isMovieAlreadySaved(movie.id) else {
      return
    }
    guard let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext) else {
      return
    }
    let savedMovie = NSManagedObject(entity: entity, insertInto: managedContext)
    savedMovie.setValue(movie.id, forKey: "id")
    savedMovie.setValue(encode(movie), forKey: "movie")
    do {
      try managedContext.save()
      movies.append(savedMovie)
    } catch {
      print("Could not save movie")
    }
  }

  func isMovieAlreadySaved(_ id: Int?) -> Bool {
    return movies.contains { movie in
      return movie.value(forKey: "id") as? Int == id
    }
  }

  func encode(_ movie: MovieOverview) -> Data? {
    do {
      let data = try JSONEncoder().encode(movie)
      return data
    } catch {
      print("Failed to encode movie")
      return nil
    }
  }

  func decode(_ data: Data) -> MovieOverview? {
    do {
      let movie = try JSONDecoder().decode(MovieOverview.self, from: data)
      return movie
    } catch {
      print("Failed to decode movie")
      return nil
    }
  }

  func getSavedMovies() {
    do {
      movies = try managedContext.fetch(fetchRequest)
    } catch {
      print("Could not fetch movies")
    }
  }

  func clearSavedMovies() {
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    do {
      try managedContext.execute(deleteRequest)
      try managedContext.save()
    } catch {
      print("Failed to clear movies")
    }
  }
}
