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
    // galleryCollectionView.setGalleryBehavior(forInfiniteScroll: false, andScaleElements: false) // diasbles infinite scroll and scaleEfect
        galleryCollectionView.setGallery(forLayout: .vertical, minLineSpacing: 10, itemSize: CGSize(width: 200, height:200), minScaleFactor: 0.5) // custom layout
        galleryCollectionView.setGallery(forLayout: .horizontal, minLineSpacing: 20, itemSize: CGSize(width: 300, height:300), minScaleFactor: 0.5) // custom layout

        galleryCollectionView.setGalleryWithCustomFlows(andStyle: .autoDynamic) // should be called after custom layout
        
        
        //galleryCollectionView.setGallery(withStyle: .autoDynamic, minLineSpacing: 10, itemSize: CGSize(width: 200, height: 200),minScaleFactor:0.2) // standart implementation
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        switch toInterfaceOrientation {
        case .landscapeLeft,.landscapeRight:
            galleryCollectionView.changeOrientation() // you need to call it in order for customLayout to receive orienatation change event
        case .portrait,.portraitUpsideDown,.unknown:
            galleryCollectionView.changeOrientation() // you need to call it in order for customLayout to receive orienatation change event
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        galleryCollectionView.recenterIfNeeded()
    }
}

class customCell :UICollectionViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
}





