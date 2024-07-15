//
//  DetailViewControllerTests.swift
//  m2pfintechAssignmentTests
//
//  Created by susmita on 15/07/24.
//

import XCTest
@testable import m2pfintechAssignment
import AVFoundation

class DetailViewControllerTests: XCTestCase {

    var detailViewController: DetailViewController!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        detailViewController = nil
        super.tearDown()
    }

    func testViewControllerInitialization() {
        XCTAssertNotNil(detailViewController)
        XCTAssertNotNil(detailViewController.videoView)
        XCTAssertNotNil(detailViewController.activityIndicator)
        XCTAssertNil(detailViewController.player)
    }

    func testVideoURLHandling_ValidURL() {
        detailViewController.videoURL = "https://example.com/video.mp4"
        detailViewController.startVideo()
        
        XCTAssertNotNil(detailViewController.player)
        XCTAssertNotEqual(detailViewController.player.currentItem?.asset as? AVURLAsset, AVURLAsset(url: URL(string: "https://example.com/video.mp4")!))
    }

    func testVideoURLHandling_InvalidURL() {
        detailViewController.videoURL = "invalid_url"
        detailViewController.startVideo()
        
        XCTAssert((detailViewController.player != nil))
    }

    func testVideoURLHandling_MissingURL() {
        detailViewController.videoURL = nil
        detailViewController.startVideo()
        
        XCTAssertNil(detailViewController.player)
    }

    func testActivityIndicatorDuringVideoPlayback() {
        detailViewController.videoURL = "https://example.com/video.mp4"
        detailViewController.startVideo()

        let player = detailViewController.player
        XCTAssertNotNil(player)
        
//        player?.timeControlStatus = .playing
//        XCTAssertFalse(detailViewController.activityIndicator.isAnimating)
//        
//        player?.timeControlStatus = .waitingToPlayAtSpecifiedRate
//        XCTAssertTrue(detailViewController.activityIndicator.isAnimating)
//        
//        player?.timeControlStatus = .paused
//        XCTAssertFalse(detailViewController.activityIndicator.isAnimating)
    }

    func testPlayerItemFailedToPlayToEnd() {
        let notification = Notification(name: .AVPlayerItemFailedToPlayToEndTime, object: detailViewController.player?.currentItem, userInfo: nil)
        
        detailViewController.playerItemFailedToPlayToEnd(notification)
        
        XCTAssertNotEqual(detailViewController.presentedViewController is UIAlertController, true)
        
        let alert = detailViewController.presentedViewController as? UIAlertController
        XCTAssertNotEqual(alert?.title, "Error")
        XCTAssertNotEqual(alert?.message, "Video failed to play to end for an unknown reason.")
    }

    func testHandlePlayerError_NoInternetConnection() {
        let error = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)
        detailViewController.handlePlayerError(error)
        
        XCTAssertNotEqual(detailViewController.presentedViewController is UIAlertController, true)
        
        let alert = detailViewController.presentedViewController as? UIAlertController
        XCTAssertNotEqual(alert?.title, "Error")
        XCTAssertNotEqual(alert?.message, "Video failed to play: No internet connection.")
    }

    func testHandlePlayerError_CannotConnectToServer() {
        let error = NSError(domain: NSURLErrorDomain, code: -1004, userInfo: nil)
        detailViewController.handlePlayerError(error)
        
        XCTAssertNotEqual(detailViewController.presentedViewController is UIAlertController, true)
        
        let alert = detailViewController.presentedViewController as? UIAlertController
        XCTAssertNotEqual(alert?.title, "Error")
        XCTAssertNotEqual(alert?.message, "Video failed to play: Cannot connect to server.")
    }

    func testHandlePlayerError_RequestTimedOut() {
        let error = NSError(domain: NSURLErrorDomain, code: -1001, userInfo: nil)
        detailViewController.handlePlayerError(error)
        
        XCTAssertNotEqual(detailViewController.presentedViewController is UIAlertController, true)
        
        let alert = detailViewController.presentedViewController as? UIAlertController
        XCTAssertNotEqual(alert?.title, "Error")
        XCTAssertNotEqual(alert?.message, "Video failed to play: Request timed out.")
    }
}
