//
//  ListViewController.swift
//  m2pfintechAssignment
//
//  Created by susmita on 13/07/24.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , MusicVideoViewModelDelegate {

    @IBOutlet weak var listTableView: UITableView!
     private let viewModel = MusicVideoViewModel()
     private var musicVideos: [MusicVideo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
          viewModel.delegate = self
          viewModel.fetchMusicVideos()
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 150
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()
    }
    func registerTableView(){
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
    }
        func didFetchMusicVideos(_ musicVideos: [MusicVideo]) {
            self.musicVideos = musicVideos
            // Update your UI here with the fetched data
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
        return musicVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell{
            let item = musicVideos[indexPath.row]
            cell.artistLabel.text = "Artist : "+item.artistName
            if let collectionName = item.collectionName {
                cell.collectionLabel.text = "Collection : "+collectionName
            }
            cell.dateLabel.text = "Release Date : "+item.releaseDate
            cell.genreLabel.text = "Genre : "+item.primaryGenreName
            cell.priceLabel.text = "Price : $"+String(item.trackPrice)
            if let imageURL = URL(string: item.artworkUrl100) {
                cell.previewImageView.loadImage(from: imageURL)
            }
            print("item \(musicVideos.count)")
            return cell
        }
        
        return UITableViewCell()
    }
 
}
