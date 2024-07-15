//
//  DetailViewController.swift
//  m2pfintechAssignment
//
//  Created by susmita on 14/07/24.
//

import UIKit
import AVFoundation
import AVKit

class DetailViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var videoURL: String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: videoURL))")
        startVideo()
    }
    func startVideo() {
        guard let videoURLString = videoURL, !videoURLString.isEmpty else {
            showErrorAlert(message: "Video URL is missing.")
            return
        }
        
        guard let videoURL = URL(string: videoURLString) else {
            showErrorAlert(message: "Invalid video URL.")
            return
        }
        
        player = AVPlayer(url: videoURL)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        
        // Observe AVPlayerItem failed notifications
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEnd(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)
        
        avpController.player = player
        avpController.view.frame = videoView.bounds
        addChild(avpController)
        videoView.addSubview(avpController.view)
        avpController.didMove(toParent: self)
        player.play()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async { [weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.activityIndicator.stopAnimating()
                    } else {
                        self?.activityIndicator.startAnimating()
                    }
                }
            }
        }
    }
    
    @objc func playerItemFailedToPlayToEnd(_ notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem, let error = playerItem.error as NSError? {
            handlePlayerError(error)
        } else {
            showErrorAlert(message: "Video failed to play to end for an unknown reason.")
        }
    }
    
    func handlePlayerError(_ error: NSError) {
        var errorMessage = "Video failed to play: "
        
        switch error.code {
        case -1009:
            errorMessage += "No internet connection."
        case -1004:
            errorMessage += "Cannot connect to server."
        case -1001:
            errorMessage += "Request timed out."
        default:
            errorMessage += error.localizedDescription
        }
        
        showErrorAlert(message: errorMessage)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    deinit {
        player?.removeObserver(self, forKeyPath: "timeControlStatus")
        NotificationCenter.default.removeObserver(self)
    }
}
