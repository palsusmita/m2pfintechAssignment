//
//  MusicVideoViewModel.swift
//  m2pfintechAssignment
//
//  Created by susmita on 12/07/24.
//

import Foundation

protocol MusicVideoViewModelDelegate: AnyObject {
    func didFetchMusicVideos(_ musicVideos: [MusicVideo])
    func didFailWithError(_ error: Error)
    func showAlert(message: String)
}

class MusicVideoViewModel {
    weak var delegate: MusicVideoViewModelDelegate?
    private let urlString = "https://itunes.apple.com/search?term=jackjohnson&entity=musicVideo"
    private let sslPinningDelegate = SSLPinningDelegate()
    
    func fetchMusicVideos() {
        if SecurityHelper.isDeviceJailbroken() {
            DispatchQueue.main.async {
                self.delegate?.showAlert(message: "Device is rooted. Aborting fetch.")
            }
            return
        }
        
        if let fileURL = getFileURLIfExists() {
            // File exists, read from it
            parseJSON(from: fileURL)
        } else {
            // File does not exist, download it
            downloadAndSaveJSON()
        }
    }
    
    private func getFileURLIfExists() -> URL? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("music_videos.json")
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
    
    private func downloadAndSaveJSON() {
        guard let url = URL(string: urlString) else { return }
        
      //  let session = URLSession(configuration: .default)
        let session = URLSession(configuration: .default, delegate: sslPinningDelegate, delegateQueue: nil)
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    print("download error")
                    self.delegate?.didFailWithError(error ?? NSError(domain: "Download Error", code: -1, userInfo: nil))
                }
                return
            }
            
            // Save the file locally
            let fileURL = self.getDocumentsDirectory().appendingPathComponent("music_videos.json")
            do {
                try data.write(to: fileURL)
                self.parseJSON(from: fileURL)
            } catch {
                DispatchQueue.main.async {
                    print("file fetch")
                    self.delegate?.didFailWithError(error)
                }
            }
        }.resume()
    }
    
    private func parseJSON(from fileURL: URL) {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let result = try JSONDecoder().decode(MusicVideoResponse.self, from: jsonData)
            DispatchQueue.main.async {
                self.delegate?.didFetchMusicVideos(result.results)
            }
        } catch {
            DispatchQueue.main.async {
                print("parse json")
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
