//
//  SearchTests.swift
//  Weather AppTests
//
//  Created by Sinothando Mabhena on 2022/04/28.
//

import XCTest
@testable import Weather_App

class SearchTests: XCTestCase {
    private var viewModel: SearchViewModel!
    private var mockDelegate: MockDelegate!
    private var mockRepository: MockRepository!

    override func setUp() {
        super.setUp()
        self.mockDelegate = MockDelegate()
        self.mockRepository = MockRepository()
        viewModel = SearchViewModel(repository: mockRepository,
                                    delegate: mockDelegate)
    }
    
    func testFetchCorrectCityName() {
        viewModel.fetchSearch("Pretoria")
        XCTAssertEqual(viewModel.cityName, "Pretoria")
    }
    
    func testFetchInCorrectCityName() {
        viewModel.fetchSearch("Joburg")
        XCTAssertNotEqual(viewModel.cityName, "Joburg")
    }
    
    func testFetchSearchSuccess() {
        viewModel.fetchSearch("Pretoria")
        XCTAssert(mockDelegate.showReloadViewCalled)
        XCTAssertFalse(mockDelegate.showErrorCalled)
    }
    
    func testFetchSearchFailure() {
        mockRepository.shouldFail = true
        viewModel.fetchSearch("Pretoria")
        XCTAssert(mockDelegate.showErrorCalled)
        XCTAssertFalse(mockDelegate.showReloadViewCalled)
    }
    
    func testCorrectSearchResponseObject() {
        viewModel.fetchSearch("Pretoria")
        XCTAssertEqual(viewModel.searchedCity?.name, "Pretoria")
    }
    
    class MockRepository: SearchRepositoryType {
        var shouldFail = false
        
        let mockData: Search = Search(coord: Coord(lon: 23.4, lat: 21.2),
                                          weather: [Weather(id: 1,
                                                            main: "Cloudy",
                                                            weatherDescription: "Cloudy sky",
                                                            icon: "cld")],
                                          base: "stations",
                                          main: Main(temp: 24,
                                                     feelsLike: 26,
                                                     tempMin: 19,
                                                     tempMax: 29,
                                                     pressure: 40,
                                                     humidity: 10),
                                          visibility: 0,
                                          wind: Wind(speed: 12.2,
                                                     deg: 14,
                                                     gust: 9.3),
                                          clouds: Clouds(all: 1),
                                          dt: 1,
                                          sys: Sys(type: 1,
                                                   id: 2,
                                                   message: 2.1,
                                                   country: "South Africa",
                                                   sunrise: 2901,
                                                   sunset: 90,
                                                   pod: "pod"),
                                          timezone: 1,
                                          id: 1,
                                          name: "Pretoria",
                                          cod: 1)
        
        func fetchSearchResults(_ cityName: String, completionHandler: @escaping SearchResponse) {
            if shouldFail {
                completionHandler(.failure(.serverError))
            } else {
                completionHandler(.success(mockData))
            }
        }
    }
    
    class MockDelegate: SearchViewModelDelegate {
        var showErrorCalled = false
        var showReloadViewCalled = false
        
        func show(error: String) {
            showErrorCalled = true
        }
        func reloadView() {
            showReloadViewCalled = true
        }
    }

}
