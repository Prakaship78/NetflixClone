//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Prakash on 22/12/22.
//

import UIKit

enum Sections : Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private var headerView : CarouselUIView?
    
    let sectionsTitles: [String] =  ["Trending Movies", "Trending Tv","Popular","Upcoming Movies","Top Rated"]
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
       
        configureNavbar()
        
        headerView = CarouselUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 350))
        homeFeedTable.tableHeaderView = headerView
        configureHeaderView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
       
    }
    
    //configure navbar
    private func configureNavbar(){
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        ApiCaller.shared.getTopRated { [weak self] results in
            switch results {
            case .success(let titles):
                self?.headerView?.configure(with: titles)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitles[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            ApiCaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.Popular.rawValue:
            ApiCaller.shared.getPopularMovies() { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.Upcoming.rawValue:
            ApiCaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.TopRated.rawValue:
            ApiCaller.shared.getTopRated { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
 


extension HomeVC : CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MovieDetailsVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

    
    



