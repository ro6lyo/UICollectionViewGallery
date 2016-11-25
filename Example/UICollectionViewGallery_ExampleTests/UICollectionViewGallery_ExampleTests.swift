//
//  UICollectionViewGallery_ExampleTests.swift
//  UICollectionViewGallery_ExampleTests
//
//  Created by Paulina Simeonova on 11/23/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import UICollectionViewGallery

class UICollectionViewGallery_ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /**
     test .autoFixed layout
     */
    func test_AutoFixedLayout() {
      /**
         2 collection view created with opposite flow layouts
        */
        let vertical = UICollectionView(frame: CGRect(x: 0, y: 0, width: 20, height: 100), collectionViewLayout: Gallery.sharedInstance.horizontalLayout)
        let horizontal = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 20), collectionViewLayout: Gallery.sharedInstance.verticalLayout)

        /**
         .autoFixed  should change their layouts based on dimenstions of each collectionview
         */
        vertical.setGallery(withStyle: .autoFixed, minLineSpacing: 10, itemSize: CGSize(width:30, height:30), minScaleFactor: 0.5)
        horizontal.setGallery(withStyle: .autoFixed, minLineSpacing: 10, itemSize: CGSize(width:30, height:30), minScaleFactor: 0.5)
        
  
        XCTAssertTrue(vertical.collectionViewLayout.isKind(of: VerticalFlowLayout.self))
        XCTAssertTrue(horizontal.collectionViewLayout.isKind(of: HorizontalFlowLayout.self))
    }
    
    func test_AutoDynamicLayout(){
        let dynamic = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 20), collectionViewLayout: Gallery.sharedInstance.horizontalLayout)
        
        dynamic.setGallery(withStyle: .autoDynamic, minLineSpacing: 10, itemSize: CGSize(width:30, height:30), minScaleFactor: 0.5)
        XCTAssertTrue(dynamic.collectionViewLayout.isKind(of: HorizontalFlowLayout.self))
        dynamic.changeOrientation()
        XCTAssertTrue(dynamic.collectionViewLayout.isKind(of: VerticalFlowLayout.self))
    }
    
    func test_VerticalLayout(){
        let vertical = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 10), collectionViewLayout: Gallery.sharedInstance.horizontalLayout)
        
        vertical.setGallery(withStyle: .vertical, minLineSpacing: 10, itemSize: CGSize(width:30, height:30), minScaleFactor: 0.5)
        XCTAssertTrue(vertical.collectionViewLayout.isKind(of: VerticalFlowLayout.self))

        vertical.frame.size.height = 500
        XCTAssertTrue(vertical.collectionViewLayout.isKind(of: VerticalFlowLayout.self))
    }
    
    func test_HorizontalLayout() {
        
        let horizontal = UICollectionView(frame: CGRect(x: 0, y: 0, width: 20, height: 100), collectionViewLayout: Gallery.sharedInstance.verticalLayout)
        
        horizontal.setGallery(withStyle: .horizontal, minLineSpacing: 10, itemSize: CGSize(width:30, height:30), minScaleFactor: 0.5)
        XCTAssertTrue(horizontal.collectionViewLayout.isKind(of: HorizontalFlowLayout.self))
        
        horizontal.frame.size.height = 500
        XCTAssertTrue(horizontal.collectionViewLayout.isKind(of: HorizontalFlowLayout.self))
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
