//
//  DashboardViewModelTest.swift
//  PulseTrackTests
//
//  Created by Salman Mhaskar on 02/01/26.
//

import XCTest
@testable import PulseTrack

@MainActor
final class DashboardViewModelTest: XCTestCase {
    
    //MARK: - Success Case
    func testLoadMetricSuccess() async{
        
        let heartRate = HeartRate(bpm: 70)
        let steps = Steps(count: 5000)
        
        let vm = DashboardViewModel(
            heartRateService: MockMetricService(result: .success(heartRate)),
            stepsService: MockMetricService(result: .success(steps))
        )
        
        vm.loadMetric()
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.error)
        XCTAssertEqual(vm.metrics.count, 2)
    }
    
    //MARK: - Failure Case
    
    func testLoadMetricFail() async{
        
        let vm = DashboardViewModel(
            heartRateService: MockMetricService(result: .failure(AppError.failedToLoad)),
            stepsService: MockMetricService(result: .failure(AppError.failedToLoad))
            )
        
        vm.loadMetric()
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertFalse(vm.isLoading)
        XCTAssertNotNil(vm.error)
        XCTAssertTrue(vm.metrics.isEmpty)
    }
}
