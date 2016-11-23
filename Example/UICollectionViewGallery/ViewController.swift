//
//  ViewController.swift
//  UICollectionViewGallery
//
//  Created by ro6lyo on 11/19/2016.
//  Copyright (c) 2016 ro6lyo. All rights reserved.
//

import UIKit
import UICollectionViewGallery





class ViewController: UIViewController {
    
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var stringArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        configureGallery()
    }
    
    
    func configureGallery() {
       
        galleryCollectionView.setGallery(withStyle: .autoFixed, minLineSpacing: 10, itemSize: CGSize(width: 200, height: 200))
      
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        switch toInterfaceOrientation {
        case .landscapeLeft,.landscapeRight:
        galleryCollectionView.changeOrientation()
            
        case .portrait,.portraitUpsideDown,.unknown:
            galleryCollectionView.changeOrientation()

        }
    }
    
    
}
//
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: customCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as? customCell)!
        cell.customLabel.text = stringArray[indexPath.row]
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        galleryCollectionView.recenterIfNeeded()
    }
    
}

class customCell :UICollectionViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
}





