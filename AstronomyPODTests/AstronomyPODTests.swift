//
//  AstronomyPODTests.swift
//  AstronomyPODTests
//
//  Created by Jehad on 2/27/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import XCTest
@testable import AstronomyPOD


class AstronomyPODTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testImageMediaType()
    {
        let mediaData = Media(data: Data(), mediaType: MediaType.image)
        XCTAssertEqual(mediaData.getMediaType(), MediaType.image)
    }
    
    func testVideoMediaType()
    {
        let mediaData = Media(data: Data(), mediaType: MediaType.video)
        XCTAssertEqual(mediaData.getMediaType(), MediaType.video)
    }
    func testUnknownMediaType()
    {
        let mediaData = Media(data: Data(), mediaType: MediaType.unknown)
        XCTAssertEqual(mediaData.getMediaType(), MediaType.unknown)
    }
    
    func testRESTAPIDownload()
    {
        let apodRestAPIAdapter = APODRestAPIAdapter(strUrl: "https://api.nasa.gov/planetary/apod?api_key=lolk5TzOPwjAU9RVPQJKfpyhRoaEN08A03wMktha")
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download POD Data")
        apodRestAPIAdapter.download() { (apodModel, error, success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
 /*
     Sample output
     
     {
     "copyright": "Henrik Adamsson",
     "date": "2018-03-01",
     "explanation": "The striking X in this lunarscape is easily visible in binoculars or a small telescope, but not too many have seen it. The catch is, this lunar X is fleeting and only apparent in the hours before the Moon's first quarter phase. Along the shadow line between lunar day and night, the X illusion is produced by a configuration of craters seen here toward the left, Blanchinus, La Caille and Purbach. Near the Moon's first quarter phase, an astronaut standing close to the craters' position would see the slowly rising Sun very near the horizon. Temporarily, crater walls would be in sunlight while crater floors would still be in darkness. Seen from planet Earth, contrasting sections of bright walls against the dark floors by chance look remarkably like an X. This sharp image of the Lunar X was captured on February 22nd. For extra credit, sweep your gaze along the lunar terminator and you can also spot the Lunar V.",
     "hdurl": "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson.jpg",
     "media_type": "image",
     "service_version": "v1",
     "title": "The Lunar X (V)",
     "url": "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson1024c.jpg"
     }
 */
    func testRESTAPIDataModel()
    {
        let apodRestAPIAdapter = APODRestAPIAdapter(strUrl: "https://api.nasa.gov/planetary/apod?api_key=lolk5TzOPwjAU9RVPQJKfpyhRoaEN08A03wMktha")
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download POD JSON Data")
        apodRestAPIAdapter.download() { (apodModel, error, success) in
            XCTAssertTrue(success)
            XCTAssertEqual(apodModel.date, "2018-03-01")
            XCTAssertEqual(apodModel.media_type, "image")
            XCTAssertEqual(apodModel.service_version , "v1")
            XCTAssertEqual(apodModel.title, "The Lunar X (V)")
            XCTAssertEqual(apodModel.hdurl, "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson.jpg")
            XCTAssertEqual(apodModel.url, "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson1024c.jpg")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testImageMediaHandler()
    {
        let mediaHandler = APODModelStrategy.getMediaHandle(mediaType: "image")
        XCTAssertTrue(mediaHandler is ImageHandler)
    }
    func testVideoMediaHandler()
    {
        let mediaHandler = APODModelStrategy.getMediaHandle(mediaType: "video")
        XCTAssertTrue(mediaHandler is VideoHandler)
    }
    func testUnknownMediaHandler()
    {
        let mediaHandler = APODModelStrategy.getMediaHandle(mediaType: "unknown")
        XCTAssertTrue(mediaHandler is UnknownHandler)
    }
    func testImageHandlerHandle(){
        let imageHandler = APODModelStrategy.getMediaHandle(mediaType: "image")
        let expectation = XCTestExpectation(description: "Download image Data")
        imageHandler.handle(strUrl: "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson1024c.jpg"){(mediaData, error, success) in
            XCTAssertTrue(success)
            XCTAssertEqual(mediaData.getMediaType(), MediaType.image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testVideoHandlerHandle(){
        let videoHandler = APODModelStrategy.getMediaHandle(mediaType: "video")
        let expectation = XCTestExpectation(description: "Download video Data")
        videoHandler.handle(strUrl: "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson1024c.jpg"){(mediaData, error, success) in
            XCTAssertFalse(success)
            XCTAssertEqual(mediaData.getMediaType(), MediaType.video)
            XCTAssertEqual(error, "Media type: Video can not be downloaded")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testUnknownHandlerHandle(){
        let unknownHandler = APODModelStrategy.getMediaHandle(mediaType: "unknown")
        let expectation = XCTestExpectation(description: "Download unknown Data")
        unknownHandler.handle(strUrl: "https://apod.nasa.gov/apod/image/1803/LunarXVAdamsson1024c.jpg"){(mediaData, error, success) in
            XCTAssertFalse(success)
            XCTAssertEqual(mediaData.getMediaType(), MediaType.unknown)
            XCTAssertEqual(error, "Media type: Unknown can not be downloaded")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    
}
