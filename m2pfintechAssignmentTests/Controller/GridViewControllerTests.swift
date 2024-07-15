//
//  GridViewControllerTests.swift
//  m2pfintechAssignmentTests
//
//  Created by susmita on 15/07/24.
//

import XCTest
@testable import m2pfintechAssignment

class GridViewControllerTests: XCTestCase {

    var viewController: GridViewController!
    var mockViewModel: MockMusicVideoViewModel!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "GridViewController", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "GridViewController") as? GridViewController
        mockViewModel = MockMusicVideoViewModel()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsFetchMusicVideos() {
        // Arrange
        let expectation = self.expectation(description: "fetchMusicVideos called")
        mockViewModel.fetchMusicVideosCalled = {
            expectation.fulfill()
        }

        // Act
        viewController.viewDidLoad()

        // Assert
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(mockViewModel.isFetchMusicVideosCalled)
    }

    func testDidFetchMusicVideos_UpdatesDataSource() {
        // Arrange
        guard let musicVideos = loadTestMusicVideos()?.results else {
            XCTFail("Failed to load test music videos")
            return
        }

        // Act
        viewController.didFetchMusicVideos(musicVideos)

        // Assert
        XCTAssertEqual(viewController.musicVideos.count, musicVideos.count)
        XCTAssertEqual(viewController.filteredMusicVideos.count, musicVideos.count)
        XCTAssertEqual(viewController.musicVideos.first?.trackName, "Test Track")
    }

    func testDidFailWithError_ShowsError() {
        // Arrange
        let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        
        // Act
        viewController.didFailWithError(error)

        // Assert
        // You could add a mock to check if an alert is presented or check log statements
    }

    func testCollectionView_NumberOfItemsInSection() {
        // Arrange
        guard let musicVideos = loadTestMusicVideos()?.results else {
            XCTFail("Failed to load test music videos")
            return
        }
        viewController.musicVideos = musicVideos
        
        // Act
        let numberOfItems = viewController.collectionView(viewController.gridCollectionView, numberOfItemsInSection: 0)

        // Assert
        XCTAssertEqual(numberOfItems, viewController.musicVideos.count)
    }

    func testCollectionView_CellForItemAt() {
        // Arrange
        guard let musicVideos = loadTestMusicVideos()?.results else {
            XCTFail("Failed to load test music videos")
            return
        }
        viewController.musicVideos = musicVideos
        viewController.gridCollectionView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Act
        let cell = viewController.collectionView(viewController.gridCollectionView, cellForItemAt: indexPath) as? GridCollectionViewCell

        // Assert
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.gridImageTitle.text, "Test Track")
    }
    
    // Helper method to load test music videos
    private func loadTestMusicVideos() -> MusicVideoResponse? {
        let jsonString = """
        {
            "resultCount": 1,
            "results": [
                {
                    "wrapperType": "track",
                    "kind": "music-video",
                    "artistId": 123456,
                    "collectionId": 123456789,
                    "trackId": 1234567890,
                    "artistName": "Test Artist",
                    "collectionName": "Test Collection",
                    "trackName": "Test Track",
                    "collectionCensoredName": "Test Collection",
                    "trackCensoredName": "Test Track",
                    "artistViewUrl": "http://test.com/artist",
                    "collectionViewUrl": "http://test.com/collection",
                    "trackViewUrl": "http://test.com/track",
                    "previewUrl": "http://test.com/preview.mp4",
                    "artworkUrl30": "http://test.com/image30.jpg",
                    "artworkUrl60": "http://test.com/image60.jpg",
                    "artworkUrl100": "http://test.com/image100.jpg",
                    "collectionPrice": 9.99,
                    "trackPrice": 1.29,
                    "releaseDate": "2024-01-01T12:00:00Z",
                    "collectionExplicitness": "notExplicit",
                    "trackExplicitness": "notExplicit",
                    "discCount": 1,
                    "discNumber": 1,
                    "trackCount": 10,
                    "trackNumber": 1,
                    "trackTimeMillis": 210000,
                    "country": "USA",
                    "currency": "USD",
                    "primaryGenreName": "Pop"
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let musicVideoResponse = try decoder.decode(MusicVideoResponse.self, from: jsonData)
            return musicVideoResponse
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

// Mock classes

class MockMusicVideoViewModel: MusicVideoViewModel {
    var isFetchMusicVideosCalled = false
    var fetchMusicVideosCalled: (() -> Void)?

    override func fetchMusicVideos() {
        isFetchMusicVideosCalled = true
        fetchMusicVideosCalled?()
    }
}
