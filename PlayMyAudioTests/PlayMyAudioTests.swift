//
//  PlayMyAudioTests.swift
//  PlayMyAudioTests
//
//  Created by Tracy Sablon on 08/01/2017.
//  Copyright © 2017 Tracy Sablon. All rights reserved.
//

import XCTest
@testable import PlayMyAudio

class PlayMyAudioTests: XCTestCase {
    
     var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDataTaskPlaylist()
    {
        let semaphore : DispatchSemaphore = DispatchSemaphore(value: 0);
        let localURL = "http://localhost:8000/"
        let allplaylistURL = "\(localURL)playlist"
        guard let requestURL = URL(string: allplaylistURL)else{
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = requestURL;
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            XCTAssertNil(error, "dataTaskWithURL error \(error)")

            if let httpResponse = response as? HTTPURLResponse
            {
                XCTAssertEqual(httpResponse.statusCode, 200, "status code was not 200")
            
            }
            
            XCTAssert((data != nil), "data is available");
            
            semaphore.signal();
        });
        task.resume();
        
   }
    
    func testDataTaskTrack()
    {
        let semaphore : DispatchSemaphore = DispatchSemaphore(value: 0);
        let trackTitle = "apashe_feat_panther-no_twerk_v2"
        let localURL = "http://localhost:8000/"
        let allplaylistURL = "\(localURL)playlist/\(trackTitle)"
        guard let requestURL = URL(string: allplaylistURL)else{
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = requestURL;
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            XCTAssertNil(error, "dataTaskWithURL error \(error)")
            
            if let httpResponse = response as? HTTPURLResponse
            {
                XCTAssertEqual(httpResponse.statusCode, 200, "status code was not 200")
                
            }
            
            XCTAssert((data != nil), "data is available");
            
            semaphore.signal();
        });
        task.resume();
        
    }
    
    func testMusicInit() {
        let track = Audio(audioId: 1, audioTitle: "song1")
        XCTAssertEqual(track.audioId, 1)
        XCTAssertEqual(track.audioTitle, "song1")
    }
    
    func testMusicInit2() {
        let data = "YXVkaW8="
        let track = Audio(audioId: 1, audioData: data, audioTitle: "song2")
        XCTAssertEqual(track.audioId, 1)
        XCTAssertEqual(track.audioData, data)
        XCTAssertEqual(track.audioTitle, "song2")

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
}
