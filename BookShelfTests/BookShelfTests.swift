//
//  BookShelfTests.swift
//  BookShelfTests
//
//  Created by steve on 2021/05/21.
//

import XCTest
import UIKit
@testable import BookShelf

class SpyDelegate : IBShelfList
{
    var text = ""
    var result: Bool? = .none
    var expectation : XCTestExpectation!
    var first = false
    var list = [BItem]()
    var item : BItem!
    
    var testTimeout  = false
    var testThumb    = false
    var testThumbAll = false
    
    var count        = 0

    func shelf(_ shelf: BShelf, onImage item: BItem) {}
    func shelf(_ shelf: BShelf, onBody  item: BItem) {}
    func shelf(_ shelf: BShelf, onList  list: [BItem]) {}
    func shelf(_ shelf: BShelf, onListError text: String?) {}
}

class Tests: XCTestCase {
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testList(find: String, desc: String, spy: SpyDelegate) -> (BShelf, SpyDelegate)
    {
        spy.expectation = expectation(description: find + ":" + desc)
        spy.text = find
        
        let shelf = BShelf()
        let cache = BCache()

        shelf.delegate = spy
        shelf.load(cache)

        shelf.rqList(text: find)

        return (shelf, spy)
    }
    
    func result(_ shelf: BShelf, _ spy: SpyDelegate, _ err: Error?) -> Bool
    {
        if let err = err {
            
            if spy.testTimeout == true {
                XCTAssertTrue(true)
                return false
            }
            
            XCTFail("waitForExpectationsWithTimeout errored: \(err)")
            return false
        }

        guard let _ = spy.result else {
            XCTFail("Expected delegate to be called")
            return false
        }

        return true
    }
}

class ShelfTests: Tests {

    class SpyListDelegate : SpyDelegate
    {
        override
        func shelf(_ shelf: BShelf, onList list: [BItem]) {
            
            if first == false
            {
                first = true
                print("\(text).total: \(shelf.total)")
            }
            else
            {
                print(".")
            }
            
            if shelf.total == list.count
            {
                result = true
                expectation.fulfill()
            }
        }
    }
    
    func resultList(_ shelf: BShelf, _ spy: SpyDelegate, _ err: Error?)
    {
        if result(shelf, spy, err) == false {
            return
        }

        print("Finds: \"\(spy.text)\" - \(shelf.total)")
        XCTAssertTrue(true)
    }

////////
    func testList_Swift() throws {
        
        let (shelf, spy) = testList(find:"Swift", desc:"Waiting ...", spy: SpyListDelegate())

        waitForExpectations(timeout: 10) {
            self.resultList(shelf, spy, $0)
        }
    }

    func testList_Apple() throws {
        let (shelf, spy) = testList(find:"Apple", desc:"Waiting ...", spy: SpyListDelegate())
        spy.testTimeout = true
        
        // wifi : 14 seconds
        waitForExpectations(timeout: 10) {

            self.resultList(shelf, spy, $0)
        }
    }

    func testList_Ddddd() throws {
        let (shelf, spy) = testList(find:"Ddddd", desc:"Waiting ...", spy: SpyListDelegate())

        waitForExpectations(timeout: 10) {

            self.resultList(shelf, spy, $0)
        }
    }
}

class ItemTests: Tests {

    class SpyItemDelegate : SpyDelegate
    {
        func thumbAll(_ shelf: BShelf, _ list: [BItem])
        {
            if first == false {
                first = true
                print("\(text).total: \(shelf.total)")
            }
            else
            {
                print(".")
            }
            
            if shelf.total > list.count { return }

            list.forEach {
                $0.rqImage()
            }
        }
        
        override
        func shelf(_ shelf: BShelf, onList list: [BItem])
        {
            if testThumbAll == true {

                thumbAll(shelf, list)

                return
            }
            
            if first == true { return }
            first = true
            
            shelf.rqList(text: "") // stop!
            
            print("\(text).total: \(shelf.total)")

            guard let item = list.first else {
                expectation.fulfill()
                return
            }
            
            item.rqBody()
            
            if testThumb == true { item.rqImage() }
            self.item = item
        }

        override
        func shelf(_ shelf: BShelf, onBody item: BItem)
        {
            if testThumb == false {
                result = true
                expectation.fulfill()
            }
        }

        override
        func shelf(_ shelf: BShelf, onImage item: BItem)
        {
            if testThumbAll
            {
                count += 1

                print("O-\(count)")

                if shelf.total == count {
                    result = true
                    expectation.fulfill()
                }

                return
            }

            result = true
            expectation.fulfill()
        }
    }

    func resultItem(_ shelf: BShelf, _ spy: SpyDelegate, _ err: Error?)
    {
        if result(shelf, spy, err) == false {
            return
        }

        if spy.testThumbAll == true {

            if spy.count != shelf.total
            {
                XCTFail("Fail - image download")
            }
            else if shelf.cache.count > shelf.cache.max
            {
                XCTFail("Fail - cache")
            }
            
            XCTAssertTrue(true)
            return
        }
        
        if spy.item == nil {
            XCTFail("No item")
            return
        }

        XCTAssertTrue(true)
    }
    
    func testItem_body()
    {
        let (shelf, spy) = testList(find:"Swift", desc:"Waiting ...", spy: SpyItemDelegate())

        waitForExpectations(timeout: 10) {

            self.resultItem(shelf, spy, $0)
        }
    }

    func testItem_thumb()
    {
        let (shelf, spy) = testList(find:"Swift", desc:"Waiting ...", spy: SpyItemDelegate())
        spy.testThumb = true
        
        waitForExpectations(timeout: 10) {

            self.resultItem(shelf, spy, $0)
        }
    }

    func testItem_thumbAll()
    {
        let (shelf, spy) = testList(find:"Swift", desc:"Waiting ...", spy: SpyItemDelegate())
        spy.testThumbAll = true
        
        // wifi 133 seconds
        waitForExpectations(timeout: 200) {

            self.resultItem(shelf, spy, $0)
        }
    }

}
