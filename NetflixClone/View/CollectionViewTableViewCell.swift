//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Prakash on 26/12/22.
//

import UIKit


protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell : CollectionViewTableViewCell, viewModel : MoviePreviewViewModel)
}

class CollectionViewTableViewCell : UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var movies: [Movie] = [Movie]()
    
    weak var delegate : CollectionViewTableViewCellDelegate?
     
     private let collectionView : UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: 144, height: 200)
         layout.scrollDirection = .horizontal
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
         return collectionView
     }()
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         contentView.backgroundColor = .systemBlue
         contentView.addSubview(collectionView)
         
         collectionView.delegate = self
         collectionView.dataSource = self
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         collectionView.frame = contentView.bounds
     }
    
    public func configure(with titles: [Movie]){
        self.movies = titles
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()

        }
    }

}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let  model =  movies[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        
        let viewModel = MoviePreviewViewModel(title: movie.original_title, posterUrl: movie.poster_path, titleOverView: movie.overview)
        self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)

        
    }
    
    
}


