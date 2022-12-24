//
//  ApiCaller.swift
//  NetflixClone
//
//  Created by Prakash on 23/12/22.
//

import Foundation

struct Constants {
    static let API_KEY = "cb2d2a72aaf2a00bb10e749c4b174d1a"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyD9dcXkPDqkfLsxhQgpkZcxNsP3-7M8DDw"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError : Error {
    case failedTogetData
}

class ApiCaller {
    static let shared = ApiCaller()
    
    func getUpcomingMovies(completion: @escaping(Result<[Movie],Error>)-> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let results = try JSONDecoder().decode(MoviesModel.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
}
