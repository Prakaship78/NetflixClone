//
//  HomeVCApiHelper.swift
//  NetflixClone
//
//  Created by Prakash on 30/12/24.
//

import UIKit

extension HomeVC {
    // call api concurrently using dispatch group
    func callAllApiConcurrently() {
        let dispatchGroup = DispatchGroup()
        
        performSelector(onMainThread: #selector(showActivityIndicator), with: nil, waitUntilDone: false)
        
        
        //header view
        dispatchGroup.enter()
        ApiCaller.shared.getTopRated { [weak self] results in
            switch results {
            case .success(let titles):
                self?.headerView?.configure(with: titles)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        // trending movies
        dispatchGroup.enter()
        ApiCaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let response):
                self?.sections.append(HomeMovies(name: "Trending TV Shows", movies: response))
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                   dispatchGroup.leave()
               }
            
            
            //popular
            dispatchGroup.enter()
            ApiCaller.shared.getPopularMovies { [weak self] result in
                switch result {
                case .success(let response):
                    self?.sections.append(HomeMovies(name: "Popular Movies", movies: response))
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                dispatchGroup.leave()
            }
            
            
            //upcoming
            dispatchGroup.enter()
            ApiCaller.shared.getUpcomingMovies { [weak self] result in
                switch result {
                case .success(let response):
                    self?.sections.append(HomeMovies(name: "Upcoming Movies", movies: response))
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
            
            
            // top rated
            dispatchGroup.enter()
            ApiCaller.shared.getTopRated { [weak self] result in
                switch result {
                case .success(let response):
                    self?.sections.append(HomeMovies(name: "Top Rated Movies", movies: response))
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                dispatchGroup.leave()
            }
        }
        
        // once all api call completed update ui
        dispatchGroup.notify(queue: .main){[weak self] in
            self?.hideActivityIndicator()
            self?.homeFeedTable.tableHeaderView = self?.headerView
            self?.homeFeedTable.reloadData()
        }
        
    }
    
   @objc func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 999 // Unique tag to find and remove it later
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    func hideActivityIndicator() {
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
