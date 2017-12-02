//
//  ASODTests.swift
//  ASODTests
//
//  Created by Максим Казаков on 11/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import XCTest
@testable import ASOD
import RealmSwift

class ASODTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    let pictureJsonString = """
    {
        "_id": "5a04916eb459f4000454775c",
        "copyright": "Guillaume Blanchard",
        "date": "2011-12-28",
        "explanation": "Comet Lovejoy (C/2011 W3) survived its close encounter with the Sun earlier this month, taking its place among wonders of the southern skies just in time for Christmas. Seen here before sunrise from Paranal Observatory in Chile, the sungrazing comet's tails stretch far above the eastern horizon. Spanning over 20 degrees they rise alongside the plane of the our Milky Way galaxy. A breathtaking spectacle in itself, Lovejoy performs on this celestial stage with southern stars and nebulae, including the Large and Small Magellanic clouds right of the telescope dome, and the glow of zodiacal light along the left edge of the frame. With Paranal's Very Large Telescope units in the foreground, this wide-angle scene was captured on December 23. Receding from the Sun, Comet Lovejoy's tails have continued to grow in length even as the comet fades.",
        "hdurl": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD.jpg",
        "media_type": "image",
        "service_version": "v1",
        "title": "Comet Lovejoy over Paranal",
        "url": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD900.jpg"
    }
    """
    
//    let pictureModel = PictureModel(value: ["date" : "2011-12-28",
//                                           "url": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD900.jpg",
//                                           "explanation": "Comet Lovejoy (C/2011 W3) survived its close encounter with the Sun earlier this month, taking its place among wonders of the southern skies just in time for Christmas. Seen here before sunrise from Paranal Observatory in Chile, the sungrazing comet's tails stretch far above the eastern horizon. Spanning over 20 degrees they rise alongside the plane of the our Milky Way galaxy. A breathtaking spectacle in itself, Lovejoy performs on this celestial stage with southern stars and nebulae, including the Large and Small Magellanic clouds right of the telescope dome, and the glow of zodiacal light along the left edge of the frame. With Paranal's Very Large Telescope units in the foreground, this wide-angle scene was captured on December 23. Receding from the Sun, Comet Lovejoy's tails have continued to grow in length even as the comet fades.",
//                                           "media_type": "image",
//                                           "title": "Comet Lovejoy over Paranal",
//                                           "hdurl": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD.jpg",
//                                           "copyright": "Guillaume Blanchard"])
    
    
    
    
    func testPictureModel() {
        let dict = PictureModel(value: ["date" : dateFormatter.date(from: "2011-11-11")!,
                                                "url": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD900.jpg",
                                                "explanation": "Comet Lovejoy (C/2011 W3) survived its close encounter with the Sun earlier this month, taking its place among wonders of the southern skies just in time for Christmas. Seen here before sunrise from Paranal Observatory in Chile, the sungrazing comet's tails stretch far above the eastern horizon. Spanning over 20 degrees they rise alongside the plane of the our Milky Way galaxy. A breathtaking spectacle in itself, Lovejoy performs on this celestial stage with southern stars and nebulae, including the Large and Small Magellanic clouds right of the telescope dome, and the glow of zodiacal light along the left edge of the frame. With Paranal's Very Large Telescope units in the foreground, this wide-angle scene was captured on December 23. Receding from the Sun, Comet Lovejoy's tails have continued to grow in length even as the comet fades.",
                                                "media_type": "image",
                                                "title": "Comet Lovejoy over Paranal",
                                                "hdurl": "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD.jpg",
                                                "copyright": "Guillaume Blanchard"])
        
        let picture = PictureModel(value: dict)
        
        XCTAssertEqual(picture.date, dateFormatter.date(from: "2011-11-11"))
        XCTAssertEqual(picture.url, "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD900.jpg")
        XCTAssertEqual(picture.explanation, "Comet Lovejoy (C/2011 W3) survived its close encounter with the Sun earlier this month, taking its place among wonders of the southern skies just in time for Christmas. Seen here before sunrise from Paranal Observatory in Chile, the sungrazing comet's tails stretch far above the eastern horizon. Spanning over 20 degrees they rise alongside the plane of the our Milky Way galaxy. A breathtaking spectacle in itself, Lovejoy performs on this celestial stage with southern stars and nebulae, including the Large and Small Magellanic clouds right of the telescope dome, and the glow of zodiacal light along the left edge of the frame. With Paranal's Very Large Telescope units in the foreground, this wide-angle scene was captured on December 23. Receding from the Sun, Comet Lovejoy's tails have continued to grow in length even as the comet fades.")
        XCTAssertEqual(picture.media_type, "image")
        XCTAssertEqual(picture.title, "Comet Lovejoy over Paranal")
        XCTAssertEqual(picture.hdurl, "https://apod.nasa.gov/apod/image/1112/IMG_9800-GBLANCHARD.jpg")
        XCTAssertEqual(picture.copyright, "Guillaume Blanchard")
    }
    
    
    
    func testNetwork() {
        let testDates = ["2017-11-11"/*, "2011-11-11", "2015-11-11"*/].map{ dateFormatter.date(from: $0)! }
        do {
            let pictures = try NetworkApiService.loadPictures(from: testDates)
            XCTAssertEqual(pictures.count, 3)
        }
        catch {
            XCTFail()
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
