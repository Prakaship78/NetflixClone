//
//  DownloadsVC.swift
//  NetflixClone
//
//  Created by Prakash on 22/12/22.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private let textLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "No Downloads"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(textLabel)
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLabel.frame = view.bounds
    }
    
  private func  applyConstraints(){
        let textLabelConstraints = [
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ]
      NSLayoutConstraint.activate(textLabelConstraints)
    }
    


}
