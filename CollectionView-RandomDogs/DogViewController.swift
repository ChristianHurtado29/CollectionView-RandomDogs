//
//  ViewController.swift
//  CollectionView-RandomDogs
//
//  Created by Christian Hurtado on 1/14/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {
    
    // NB: as of iOAS 13 collection view cells are self-resizing by default
    // in order to not self-resize we have to set "estimated size" from automatic to none
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var dogImages = [DogImage]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .orange

        fetchDogImages()
    }

    private func fetchDogImages() {
        DogAPIClient.fetchDogs{ [weak self] (result) in
            switch result {
            case .failure (let appError):
                print("Could not fetch dog images with error \(appError)")
            case .success (let dogImages):
                self?.dogImages = dogImages
            }
        }
    }
}

extension DogViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dogImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as? DogCell else{
            fatalError("Could not downcast to dogcell")
        }
        let dogImage = dogImages[indexPath.row]
        cell.configureCell(with: dogImage)
        return cell
    }
}

// here we are using UICollectionViewFlowLayout

extension DogViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing = CGFloat(10)
        let maxWidth = UIScreen.main.bounds.size.width // device's width
//      let maxHeight = UIScreen.main.bounds.size.height
        let numberOfItems: CGFloat = 3 // items per row
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        //this sizing is so it prints squares.
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
}
