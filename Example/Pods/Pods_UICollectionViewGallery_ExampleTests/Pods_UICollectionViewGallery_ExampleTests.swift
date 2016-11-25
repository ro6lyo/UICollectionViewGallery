//
//  Pods_UICollectionViewGallery_ExampleTests.swift
//  Pods_UICollectionViewGallery_ExampleTests
//
//  Created by Mehmed Kadir on 11/23/16.
//
//

import XCTest
import UIKit
import Foundation

class Pods_UICollectionViewGallery_ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateVerticalScrollGallery(){
        
        let gallery = UICollectionView()
        gallery.frame.size.width = 100
        gallery.frame.size.height = 200
        
        
    }
    
    
    
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
