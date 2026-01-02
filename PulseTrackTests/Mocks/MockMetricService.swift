//
//  MockMetricService.swift
//  PulseTrackTests
//
//  Created by Salman Mhaskar on 02/01/26.
//

import Foundation
@testable import PulseTrack

final class MockMetricService: MetricServiceProtocol{
    
    private let result: Result<Metric, Error>
    
    init(result: Result<Metric, Error>) {
        self.result = result
    }
    
    func fetchMetric() async throws ->  Metric {
        switch result {
        case .success(let metric):
            return metric
        case .failure(let error):
            throw error
        }
    }
}
