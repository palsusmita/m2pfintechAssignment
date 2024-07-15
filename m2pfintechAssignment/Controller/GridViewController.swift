//
//  GridViewController.swift
//  m2pfintechAssignment
//
//  Created by susmita on 13/07/24.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MusicVideoViewModelDelegate {

    @IBOutlet weak var gridCollectionView: UICollectionView!
    public var viewModel = MusicVideoViewModel()
    public var musicVideos: [MusicVideo] = []
    public var filteredMusicVideos: [MusicVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCell()
        setupCollectionViewLayout()
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        viewModel.delegate = self
        viewModel.fetchMusicVideos()
    }
    
    func registerCollectionViewCell() {
        let nibName = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        gridCollectionView.register(nibName, forCellWithReuseIdentifier: "GridCollectionViewCell")
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Vertical scroll direction for rows
        layout.minimumLineSpacing = 10 // Space between rows
        layout.minimumInteritemSpacing = 10 // Space between items in a row
        
        let numberOfColumns: CGFloat = 2 // Number of items per row
        let totalSpacing = (numberOfColumns - 1) * layout.minimumInteritemSpacing
        let width = (gridCollectionView.frame.width - totalSpacing) / numberOfColumns
        
        // Set the item size based on the calculated width
        layout.itemSize = CGSize(width: width, height: 100) // Adjust height as needed
        
        gridCollectionView.collectionViewLayout = layout
    }
    func didFetchMusicVideos(_ musicVideos: [MusicVideo]) {
        self.musicVideos = musicVideos
        self.filteredMusicVideos = musicVideos // Initialize the filtered array
        DispatchQueue.main.async {
            self.gridCollectionView.reloadData()
        }
        print(musicVideos)
    }
    
    func didFailWithError(_ error: Error) {
        // Handle the error appropriately
        print("Failed with error: \(error.localizedDescription)")
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
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicVideos.count // Adjust the number of items as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
        let item = musicVideos[indexPath.row]
        if let imageURL = URL(string: item.artworkUrl100) {
            cell.gridImage.loadImage(from: imageURL)
        }
        cell.gridImageTitle.text = item.trackName
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return .init(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let detailVC = detailStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let item = filteredMusicVideos[indexPath.row]
        detailVC.videoURL = item.previewUrl
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
