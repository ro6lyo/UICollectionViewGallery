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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var horizontal: UICollectionView!
    var stringArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let verticalLayout = VerticalLinearFlowLayout()
    var horizontalLayout = LGHorizontalLinearFlowLayout()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        horizontal.delegate = self
        horizontal.dataSource = self
        
        collectionView.isPagingEnabled = false
        horizontal.isPagingEnabled = false
      
      prepareforInfinityscroll()
       configureFirstApprouch()
        configureSecondApprouch()
    }
    func prepareforInfinityscroll() {
        let first = stringArray.first
        let last = stringArray.last
        
        stringArray.insert(last!, at: 0)
        stringArray.append(first!)
        
    }
    
    
    func configureFirstApprouch(){
         collectionView.setScaledDesginParam(scaledPattern: .horizontalCenter, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
    }
    
    func configureSecondApprouch() {
        verticalLayout.scrollDirection = .vertical
        verticalLayout.minimumLineSpacing = 10
        verticalLayout.itemSize = CGSize(width: 200, height: 200)
        
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.minimumLineSpacing = 10
        horizontalLayout.itemSize = CGSize(width: 200, height: 200)

    horizontal.decelerationRate = UIScrollViewDecelerationRateFast
    horizontal.collectionViewLayout = verticalLayout  // initail layout
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        horizontal.collectionViewLayout.invalidateLayout()
        switch toInterfaceOrientation {
        case .landscapeLeft,.landscapeRight:
            horizontal.collectionViewLayout = self.horizontalLayout
        case .portrait,.portraitUpsideDown,.unknown:
            horizontal.collectionViewLayout = self.verticalLayout
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
    
}


//
// MARK: - UIScrollViewDelegate
//
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isKind(of: UICollectionView.self) else {return}
        guard (scrollView as! UICollectionView).tag == 1 else {
            return}
        
      
        collectionView.scaledVisibleCells()
    }
}
class customCell :UICollectionViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
}
