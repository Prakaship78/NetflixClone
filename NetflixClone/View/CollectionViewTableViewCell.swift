//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Prakash on 26/12/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTap(_ cell : CollectionViewTableViewCell, viewMode: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    
    private var movies : [Movie] = [Movie]()

    weak var delegate : CollectionViewTableViewCellDelegate?
    
    private let collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140,height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
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
    
    public func configure(with movies : [Movie]){
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension CollectionViewTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let model = movies[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.configure(with: model)
        return cell
    }
    
}
