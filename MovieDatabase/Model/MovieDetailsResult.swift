import Foundation

struct MovieDetailsResult: Decodable {
  let adult: Bool?
  let backdropPath: String?
  let collection: Collection?
  let budget: Int?
  let genre: [Genre]?
  let homepage: String?
  let id: Int?
  let imdbId: String?
  let language: String?
  let overview: String?
  let popularity: Double?
  let posterPath: String?
  let productionCompanies: [ProductionCompany]?
  let productionCountries: [ProductionCountry]?
  let releaseDate: String?
  let revenue: Int?
  let runtime: Int?
  let spokenLanguages: [SpokenLanguage]?
  let status: String?
  let tagline: String?
  let title: String?
  let video: Bool?
  let voteAverage: Double?
  let voteCount: Int?

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case collection = "belongs_to_collection"
    case budget
    case genre
    case homepage
    case id
    case imdbId = "imdb_id"
    case language = "original_language"
    case overview
    case popularity
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case releaseDate = "release_date"
    case revenue
    case runtime
    case spokenLanguages = "spoken_languages"
    case status
    case tagline
    case title
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  var score: String {
    return "\(voteAverage ?? 0)"
  }

  var date: String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: releaseDate ?? "") else {
      return ""
    }
    let customDateFormatter = DateFormatter()
    customDateFormatter.dateStyle = .medium
    return customDateFormatter.string(from: date)
  }
}

struct Collection: Decodable {
  let id: Int?
  let name: String?
  let poster_path: String?
  let backdrop_path: String?
}

struct Genre: Decodable {
  let id: Int?
  let name: String?
}

struct ProductionCompany: Decodable {
  let id: Int?
  let logo_path: String?
  let name: String?
  let origin_country: String?
}

struct ProductionCountry: Decodable {
  let iso_3166_1: String?
  let name: String?
}

struct SpokenLanguage: Decodable {
  let iso_639_1: String?
  let name: String?
}
