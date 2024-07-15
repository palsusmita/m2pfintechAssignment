//
//  ImageLoader.swift
//  m2pfintechAssignment
//
//  Created by susmita on 14/07/24.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() { }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
