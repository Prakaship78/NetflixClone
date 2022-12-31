//
//  CarouselUIView.swift
//  NetflixClone
//
//  Created by Prakash on 31/12/22.
//

import UIKit

class CarouselUIView: UIView {
    
    private var movies : [Movie] = [Movie]()
    
    private var currentCellIndex : Int = 0
    
    private let collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 390,height: 150)
         layout.scrollDirection = .horizontal
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
         return collectionView
    }()
    
    private var timer : Timer?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionview)
        collectionview.delegate = self
        collectionview.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
      
    }
    
    @objc func slideToNext(){
        if(currentCellIndex <  movies.count - 1){
            currentCellIndex += 1
        }else{
            currentCellIndex = 0
        }

        collectionview.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .right, animated: true)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("Carousel error");
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionview.frame = bounds
    }
    

}

extension CarouselUIView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    
    
    public func configure(with models : [Movie]){
        self.movies = models
        DispatchQueue.main.async { [weak self] in 
            self?.collectionview.reloadData()
        }
    }
    
    
}


