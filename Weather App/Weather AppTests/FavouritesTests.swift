//
//  FavouritesTests.swift
//  Weather AppTests
//
//  Created by Sinothando Mabhena on 2022/04/29.
//

import XCTest
import CoreData
@testable import Weather_App

class FavouritesTests: XCTestCase {
    private var viewModel: FavouriteViewModel!
    private var mockDelegate: MockDelegate!
    private var mockRepository: MockRepository!

    override func setUp() {
        super.setUp()
        self.mockDelegate = MockDelegate()
        self.mockRepository = MockRepository()
        self.viewModel = FavouriteViewModel(delegate: mockDelegate,
                                          repository: mockRepository)
    }
    
    func testCorrectLocationsCount() {
        viewModel.allSavedLocations()
        XCTAssertEqual(viewModel.locationsCount, 3)
    }
    
    func testIncorrectLocationsCount() {
        viewModel.allSavedLocations()
        XCTAssertNotEqual(viewModel.locationsCount, 1)
    }
    
    func testLocationsList() {
        viewModel.allSavedLocations()
        XCTAssertNotNil(viewModel.locationList)
    }
    
    func testCreateLocationItemSucccess() {
        viewModel.allSavedLocations()
        XCTAssertFalse(mockDelegate.reloadViewCalled)
    }
    
    func testAllSavedLocationFailure() {
        mockRepository.shouldFail = true
        
        viewModel.allSavedLocations()
        XCTAssert(mockDelegate.showErrorCalled)
    }
    
    func testGetCorrectFirstLocation() {
        viewModel.allSavedLocations()
        XCTAssertNotNil(viewModel.location(atIndex: 0))
    }
    
    class TestCoreDataStack: NSObject {
        lazy var persistentContainer: NSPersistentContainer = {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "Weather_App")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
    }
    
    class MockDelegate: FavouriteViewModelDelegate {
        var reloadViewCalled = false
        var showErrorCalled = false
        
        func reloadView() {
            reloadViewCalled = true
        }
        
        func show(error: String) {
            showErrorCalled = true
        }
    }
    
    class MockRepository: FavouriteRepositoryType {
        var shouldFail = false
        
        func createLocationItem(location: Response?, completion: @escaping (CreateLocation)) {
            if shouldFail {
                completion(.failure(.createError))
            } else {
                let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
                
                let mockFavouriteLocation = Location(context: context)
                mockFavouriteLocation.location = "Pretoria"
                
                do {
                    print("here")
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(.createError))
                }
            }
        }
        
        func fetchSavedLocations(completion: @escaping (SavedLocationsResult)) {
            let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
            
            let mockFavouriteLocationOne = Location(context: context)
            let mockFavouriteLocationTwo = Location(context: context)
            let mockFavouriteLocationThree = Location(context: context)
            
            mockFavouriteLocationOne.location = "Pretoria"
            mockFavouriteLocationTwo.location = "London"
            mockFavouriteLocationThree.location = "Tokyo"
            let savedLocations: [Location] = [mockFavouriteLocationOne,
                                              mockFavouriteLocationTwo,
                                              mockFavouriteLocationThree]
            
            if shouldFail {
                completion(.failure(.fetchError))
            } else {
                completion(.success(savedLocations))
            }
        }
        
        func isLocationSaved(location: Response?, completion: @escaping (IsLocationSaved)) {
            if shouldFail {
                completion(.failure(.fetchError))
            } else {
                
            }
        }
        
    }
}
