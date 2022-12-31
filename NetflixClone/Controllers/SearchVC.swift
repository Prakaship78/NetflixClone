//
//  SearchVC.swift
//  NetflixClone
//
//  Created by Prakash on 22/12/22.
//

import UIKit

class SearchVC: UIViewController {
    
    private var movies : [Movie] = [Movie]()
    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a Movies and Tv Shows"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(MovieTableTableViewCell.self, forCellReuseIdentifier: MovieTableTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Top Searches"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        fetchTopSearches()
        searchController.searchResultsUpdater = self
    }
    
    private func fetchTopSearches(){
        ApiCaller.shared.getTopSearchesMovies {[weak self] results in
            switch results {
            case.success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    
}

extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableTableViewCell.identifier, for: indexPath) as? MovieTableTableViewCell else {return UITableViewCell()}
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: movie.original_title ?? "No Title", posterUrl: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

extension SearchVC : UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let querry = searchBar.text,
              !querry.trimmingCharacters(in: .whitespaces).isEmpty,
              querry.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else {return}
        ApiCaller.shared.search(with: querry) {results in
            switch results {
            case.success(let movies):
                DispatchQueue.main.async {
                    resultsController.movies = movies
                    resultsController.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    
}
