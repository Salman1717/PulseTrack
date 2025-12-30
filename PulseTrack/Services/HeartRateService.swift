//
//  HeartRateService.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//MARK: Concreate Service responsible for fetching heart rate data
// Declared as final as it is not meant to be subclassed

final class HeartRateService: MetricServiceProtocol {
    
    func fetchMetric() async throws -> Metric {
        ///Simulate network or sensor delay
        ///This ensures that the UI remains Responsive
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        ///Mock Heart data
        
        return HeartRate(bpm: Int.random(in: 60...110))
    }
}
