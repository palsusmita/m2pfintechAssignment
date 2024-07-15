//
//  MockMusicVideoViewModelTest.swift
//  m2pfintechAssignmentTests
//
//  Created by susmita on 15/07/24.
//

import XCTest
@testable import m2pfintechAssignment

class MockMusicVideoViewModelTest: MusicVideoViewModel {
    var fetchMusicVideosCalled = false

    override func fetchMusicVideos() {
        fetchMusicVideosCalled = true
        delegate?.didFetchMusicVideos(createMockMusicVideos())
    }

    private func createMockMusicVideos() -> [MusicVideo] {
        return [
            MusicVideo(wrapperType: "musicVideo", kind: "music-video", artistId: 1, collectionId: nil, trackId: 1, artistName: "Artist 1", collectionName: "Collection 1", trackName: "Track 1", collectionCensoredName: nil, trackCensoredName: "Track 1", artistViewUrl: "https://example.com/artist1", collectionViewUrl: nil, trackViewUrl: "https://example.com/track1", previewUrl: "https://example.com/preview1", artworkUrl30: "https://example.com/artwork30", artworkUrl60: "https://example.com/artwork60", artworkUrl100: "https://example.com/artwork100", collectionPrice: nil, trackPrice: 1.99, releaseDate: "2023-09-04T14:05:37Z", collectionExplicitness: "explicit", trackExplicitness: "explicit", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: 200000, country: "USA", currency: "USD", primaryGenreName: "Pop"),
            MusicVideo(wrapperType: "musicVideo", kind: "music-video", artistId: 2, collectionId: nil, trackId: 2, artistName: "Artist 2", collectionName: "Collection 2", trackName: "Track 2", collectionCensoredName: nil, trackCensoredName: "Track 2", artistViewUrl: "https://example.com/artist2", collectionViewUrl: nil, trackViewUrl: "https://example.com/track2", previewUrl: "https://example.com/preview2", artworkUrl30: "https://example.com/artwork30", artworkUrl60: "https://example.com/artwork60", artworkUrl100: "https://example.com/artwork100", collectionPrice: nil, trackPrice: 2.99, releaseDate: "2023-09-05T14:05:37Z", collectionExplicitness: "explicit", trackExplicitness: "explicit", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: 300000, country: "USA", currency: "USD", primaryGenreName: "Rock")
        ]
    }
}

