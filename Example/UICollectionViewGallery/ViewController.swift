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
    let verticalLayout = VerticalFlowLayout()
    var horizontalLayout = HorizontalFlowLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.isPagingEnabled = false
        
        configureGallery()
    }
    
    
    func configureGallery() {
        verticalLayout.minimumLineSpacing = 10
        verticalLayout.itemSize = CGSize(width: 200, height: 200)
        
        horizontalLayout.minimumLineSpacing = 10
        horizontalLayout.itemSize = CGSize(width: 200, height: 200)
        
        galleryCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        galleryCollectionView.collectionViewLayout = verticalLayout
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        switch toInterfaceOrientation {
        case .landscapeLeft,.landscapeRight:
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.galleryCollectionView.collectionViewLayout.invalidateLayout()
                self.galleryCollectionView.setCollectionViewLayout(self.horizontalLayout, animated: false)
            }
            
        case .portrait,.portraitUpsideDown,.unknown:
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.galleryCollectionView.collectionViewLayout.invalidateLayout()
                self.galleryCollectionView.setCollectionViewLayout(self.verticalLayout, animated: false)
            }
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
        if galleryCollectionView.collectionViewLayout.isKind(of: VerticalFlowLayout.self) {
            let layout = galleryCollectionView.collectionViewLayout as! VerticalFlowLayout
            layout.recenterIfNeeded()
        } else if galleryCollectionView.collectionViewLayout.isKind(of: HorizontalFlowLayout.self){
            let layout = galleryCollectionView.collectionViewLayout as! HorizontalFlowLayout
            layout.recenterIfNeeded()
        }
    }
    
}

class customCell :UICollectionViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
}

