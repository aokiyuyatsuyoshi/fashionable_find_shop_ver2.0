//
//  find_shopTests.swift
//  find_shopTests
//
//  Created by Yuya Aoki on 2020/04/12.
//  Copyright © 2020 Yuya Aoki. All rights reserved.
//

import XCTest
@testable import find_shop

class find_shopTests: XCTestCase{
    
     var viewController: ViewController!
     var top_viewController : Top_ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

     func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct results.
        //shop_listをテスト（スターバックスを選択）
        func test1(){
            let starbucks_encode : String = "%E3%82%B9%E3%82%BF%E3%83%BC%E3%83%90%E3%83%83%E3%82%AF%E3%82%B9"
            let test_shop = viewController?.shop_list(shop: "スターバックス")
            XCTAssertEqual(starbucks_encode, test_shop)
        }
        //shop_listをテスト(タリーズコーヒーを選択)
        func test2(){
            let tullys_encode : String = "%E3%82%BF%E3%83%AA%E3%83%BC%E3%82%BA%E3%82%B3%E3%83%BC%E3%83%92%E3%83%BC"
            let test_shop = viewController?.shop_list(shop: "タリーズコーヒー")
            XCTAssertEqual(tullys_encode, test_shop)

        }
        //numberOfComponentsをテスト
        func test3(){
            weak var distance: UIPickerView!
            let test_picker = top_viewController?.numberOfComponents(in: distance)
            XCTAssertEqual(1, test_picker)
            
        }
        //decide_shopをテスト
        func test4(){
            let test_decide_shop = viewController?.decide_shop()
            XCTAssertEqual("Starbucks", test_decide_shop)
        }
        //decide_distanceをテスト
        func test5(){
            let test_decide_distance = viewController?.decide_distance()
            XCTAssertEqual("2km", test_decide_distance)
        }
        
        
            
        }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
