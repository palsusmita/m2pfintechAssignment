//
//  ListViewController.swift
//  m2pfintechAssignment
//
//  Created by susmita on 13/07/24.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MusicVideoViewModelDelegate, UISearchBarDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listSearch: UISearchBar!
    
    public var viewModel = MusicVideoViewModel()
    public var musicVideos: [MusicVideo] = []
    public var filteredMusicVideos: [MusicVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        viewModel.delegate = self
        viewModel.fetchMusicVideos()
        listTableView.dataSource = self
        listTableView.delegate = self
        listSearch.delegate = self
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 150
        listSearch.showsCancelButton = true // Show cancel button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()
    }
    
    func registerTableView() {
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
    }
    
    func didFetchMusicVideos(_ musicVideos: [MusicVideo]) {
        self.musicVideos = musicVideos
        self.filteredMusicVideos = musicVideos // Initialize the filtered array
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
        print(musicVideos)
    }
    
    func didFailWithError(_ error: Error) {
        // Handle the error appropriately
        print("Failed with error: \(error.localizedDescription)")
        showAlert(message: "Failed with error: \(error.localizedDescription)")
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.fetchMusicVideos()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMusicVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell {
            let item = filteredMusicVideos[indexPath.row]
            cell.artistLabel.text = "Artist: " + item.artistName
            if let collectionName = item.collectionName {
                cell.collectionLabel.text = "Collection: " + collectionName
            }
            let dateString = "2023-09-04 14:05:37"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
            cell.genreLabel.text = "Genre: " + item.primaryGenreName
            cell.priceLabel.text = "Price: $" + String(item.trackPrice)
            if let imageURL = URL(string: item.artworkUrl100) {
                cell.previewImageView.loadImage(from: imageURL)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after selection (optional)
        tableView.deselectRow(at: indexPath, animated: true)
        let detailStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let detailVC = detailStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let item = filteredMusicVideos[indexPath.row]
        detailVC.videoURL = item.previewUrl
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMusicVideos = musicVideos
        } else {
            filteredMusicVideos = musicVideos.filter { musicVideo in
                return musicVideo.artistName.lowercased().contains(searchText.lowercased()) ||
                       (musicVideo.collectionName?.lowercased().contains(searchText.lowercased()) ?? false) ||
                       musicVideo.primaryGenreName.lowercased().contains(searchText.lowercased())
            }
        }
        listTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredMusicVideos = musicVideos
        listTableView.reloadData()
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard when search button is clicked
    }
}
