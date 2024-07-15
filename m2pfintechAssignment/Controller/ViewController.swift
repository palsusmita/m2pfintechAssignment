//
//  ViewController.swift
//  m2pfintechAssignment
//
//  Created by susmita on 12/07/24.
//

import UIKit

class ViewController: UIViewController {
  
    public lazy var listVC: ListViewController = {
        let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    public lazy var gridVC: GridViewController = {
        let storyboard = UIStoryboard(name: "GridViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup to show the first view controller
        listVC.view.isHidden = false
        gridVC.view.isHidden = true
    }

    public func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        viewController.view.isHidden = true
    }
    
    @IBAction func didTapSegment(segment: UISegmentedControl) {
        listVC.view.isHidden = true
        gridVC.view.isHidden = true
        
        if segment.selectedSegmentIndex == 0 {
            listVC.view.isHidden = false
        } else {
            gridVC.view.isHidden = false
        }
    }
}
