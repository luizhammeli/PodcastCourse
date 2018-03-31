//
//  FavoritesController.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 25/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var favorites = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpColectionView()
        addGestureRecognizer()
        favorites = UserDefaults.fetchFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoritesController), name: .updateFavoritesController , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionViewData), name: .updateFavoritesCollectionViewData , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    func setUpColectionView(){
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoritesCollectionViewCell
        cell.podcast = favorites[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.view.frame.width - 48)/2
        return CGSize(width: size, height: size+42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesViewController = EpisodesViewController()
        episodesViewController.podcast = favorites[indexPath.item]
        self.collectionView?.deselectItem(at: indexPath, animated: true)
        self.navigationController?.pushViewController(episodesViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 64)
    }
    
    @objc func updateFavoritesController(){
        self.navigationController?.tabBarItem.badgeColor = .purple
        self.navigationController?.tabBarItem.badgeValue = "New"
        updateCollectionViewData()
    }
    
    @objc func updateCollectionViewData(){
        favorites = UserDefaults.fetchFavorites()
        collectionView?.reloadData()
    }
    
    func addGestureRecognizer(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGestureRecognizer))
        self.collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleGestureRecognizer(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let location = gesture.location(in: collectionView)
            guard let indexPath = collectionView?.indexPathForItem(at: location) else {return}
            showRemoveFavoriteAlert(indexPath)
        }
    }
    
    func showRemoveFavoriteAlert(_ indexPath: IndexPath){
        let alert = UIAlertController(title: "Remove Podcast?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.favorites.remove(at: indexPath.item)
            self.collectionView?.deleteItems(at: [indexPath])
            UserDefaults.saveFavorites(self.favorites)
            self.collectionView?.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
