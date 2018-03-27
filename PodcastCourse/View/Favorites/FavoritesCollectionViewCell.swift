//
//  FavoritesCollectionViewCell.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 25/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    var podcast: Podcast?{
        didSet{
            guard let podcast = podcast else {return}
            artistNamelabel.text = podcast.artistName
            trackNamelabel.text = podcast.trackName
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else {return}
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        //imageView.image = #imageLiteral(resourceName: "icon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let trackNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lets Build That App"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.black
        return label
    }()
    
    let artistNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Brian Voong"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        let stackView = UIStackView(arrangedSubviews: [imageView, trackNamelabel, artistNamelabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 1
        stackView.axis = .vertical
        
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        trackNamelabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        artistNamelabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }    
}
