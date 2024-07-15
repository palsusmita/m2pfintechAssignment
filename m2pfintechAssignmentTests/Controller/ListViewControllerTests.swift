//
//  ListViewControllerTests.swift
//  m2pfintechAssignmentTests
//
//  Created by susmita on 15/07/24.
//

import XCTest
@testable import m2pfintechAssignment

class ListViewControllerTests: XCTestCase {

    var listViewController: ListViewController!
    var mockViewModel: MockMusicVideoViewModelTest!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
        listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        listViewController.loadViewIfNeeded()
        
        mockViewModel = MockMusicVideoViewModelTest()
        listViewController.viewModel = mockViewModel
        mockViewModel.delegate = listViewController
    }

    override func tearDown() {
        listViewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewDidLoad_SetsDelegates() {
        XCTAssertTrue(listViewController.listTableView.dataSource === listViewController)
        XCTAssertTrue(listViewController.listTableView.delegate === listViewController)
        XCTAssertTrue(listViewController.listSearch.delegate === listViewController)
    }

    func testDidFetchMusicVideos_SetsMusicVideosAndReloadsTableView() {
        let musicVideos = createMockMusicVideos()
        listViewController.didFetchMusicVideos(musicVideos)
        
        XCTAssertEqual(listViewController.musicVideos.count, musicVideos.count)
        XCTAssertEqual(listViewController.filteredMusicVideos.count, musicVideos.count)
        XCTAssertTrue(listViewController.listTableView.numberOfRows(inSection: 0) == musicVideos.count)
    }

    func testSearchBarTextDidChange_FiltersMusicVideos() {
        let musicVideos = createMockMusicVideos()
        listViewController.didFetchMusicVideos(musicVideos)
        
        listViewController.searchBar(listViewController.listSearch, textDidChange: "Artist 1")
        
        XCTAssertEqual(listViewController.filteredMusicVideos.count, 1)
        XCTAssertEqual(listViewController.filteredMusicVideos[0].artistName, "Artist 1")
    }

    func testSearchBarCancelButtonClicked_ResetsFilteredMusicVideos() {
        let musicVideos = createMockMusicVideos()
        listViewController.didFetchMusicVideos(musicVideos)
        
        listViewController.searchBar(listViewController.listSearch, textDidChange: "Artist 1")
        listViewController.searchBarCancelButtonClicked(listViewController.listSearch)
        
        XCTAssertEqual(listViewController.filteredMusicVideos.count, musicVideos.count)
        XCTAssertTrue(listViewController.listTableView.numberOfRows(inSection: 0) == musicVideos.count)
    }

//    func testTableViewDidSelectRow_NavigatesToDetailViewController() {
//        let navigationController = UINavigationController(rootViewController: listViewController)
//        let musicVideos = createMockMusicVideos()
//        listViewController.didFetchMusicVideos(musicVideos)
//        
//        listViewController.tableView(listViewController.listTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//        
//        XCTAssertTrue(navigationController.topViewController is DetailViewController)
//        let detailVC = navigationController.topViewController as! DetailViewController
//        XCTAssertEqual(detailVC.videoURL, musicVideos[0].previewUrl)
//    }

    // Helper method to create mock music videos
    private func createMockMusicVideos() -> [MusicVideo] {
        return [
            MusicVideo(wrapperType: "musicVideo", kind: "music-video", artistId: 1, collectionId: nil, trackId: 1, artistName: "Artist 1", collectionName: "Collection 1", trackName: "Track 1", collectionCensoredName: nil, trackCensoredName: "Track 1", artistViewUrl: "https://example.com/artist1", collectionViewUrl: nil, trackViewUrl: "https://example.com/track1", previewUrl: "https://example.com/preview1", artworkUrl30: "https://example.com/artwork30", artworkUrl60: "https://example.com/artwork60", artworkUrl100: "https://example.com/artwork100", collectionPrice: nil, trackPrice: 1.99, releaseDate: "2023-09-04T14:05:37Z", collectionExplicitness: "explicit", trackExplicitness: "explicit", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: 200000, country: "USA", currency: "USD", primaryGenreName: "Pop"),
            MusicVideo(wrapperType: "musicVideo", kind: "music-video", artistId: 2, collectionId: nil, trackId: 2, artistName: "Artist 2", collectionName: "Collection 2", trackName: "Track 2", collectionCensoredName: nil, trackCensoredName: "Track 2", artistViewUrl: "https://example.com/artist2", collectionViewUrl: nil, trackViewUrl: "https://example.com/track2", previewUrl: "https://example.com/preview2", artworkUrl30: "https://example.com/artwork30", artworkUrl60: "https://example.com/artwork60", artworkUrl100: "https://example.com/artwork100", collectionPrice: nil, trackPrice: 2.99, releaseDate: "2023-09-05T14:05:37Z", collectionExplicitness: "explicit", trackExplicitness: "explicit", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: 300000, country: "USA", currency: "USD", primaryGenreName: "Rock")
        ]
    }
}
