//
//  ViewControllerTests.swift
//  m2pfintechAssignmentTests
//
//  Created by susmita on 15/07/24.
//
import XCTest
@testable import m2pfintechAssignment

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func testViewDidLoad_SetsInitialChildViewControllers() {
        // Ensure both child view controllers are added and initially hidden state is correct
        XCTAssertNotNil(viewController.listVC)
        XCTAssertNotNil(viewController.gridVC)
        
        XCTAssertFalse(viewController.listVC.view.isHidden, "listVC should be visible")
        XCTAssertTrue(viewController.gridVC.view.isHidden, "gridVC should be hidden")
    }

    func testDidTapSegment_SwitchesViewControllers() {
        // Mock the UISegmentedControl
        let segment = UISegmentedControl(items: ["List", "Grid"])
        
        // Act: Switch to the grid view
        segment.selectedSegmentIndex = 1
        viewController.didTapSegment(segment: segment)
        
        // Assert: List should be hidden and grid should be visible
        XCTAssertTrue(viewController.listVC.view.isHidden, "listVC should be hidden")
        XCTAssertFalse(viewController.gridVC.view.isHidden, "gridVC should be visible")
        
        // Act: Switch back to the list view
        segment.selectedSegmentIndex = 0
        viewController.didTapSegment(segment: segment)
        
        // Assert: List should be visible and grid should be hidden
        XCTAssertFalse(viewController.listVC.view.isHidden, "listVC should be visible")
        XCTAssertTrue(viewController.gridVC.view.isHidden, "gridVC should be hidden")
    }
    
    func testAddAsChildViewController_AddsChildViewController() {
        // Arrange
        let childViewController = UIViewController()
        
        // Act
        viewController.add(asChildViewController: childViewController)
        
        // Assert
        XCTAssertTrue(viewController.children.contains(childViewController), "Child view controller should be added")
        XCTAssertTrue(viewController.view.subviews.contains(childViewController.view), "Child view controller's view should be added to the parent view")
    }
}
