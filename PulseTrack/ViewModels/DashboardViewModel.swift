//
//  DashboardViewModel.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation
import Combine

//MARK: Dashboard ViewModel
// Handles Business logic and async operations
// Annoted with @MainActor to ensure UI state updates happen on main thread

@MainActor
final class DashboardViewModel: ObservableObject{
    
    //MARK: -  Published States
    
    ///Currently Displayed metric
    @Published private(set) var metric: Metric?
    
    ///Controls Loading State in the UI
    @Published var isLoading: Bool = false
    
    //MARK: - Dependencies
    
    ///Service Injected to fetch metric data
    private let service: MetricServiceProtocol
    
    //MARK: - Initializer
    
    init(service: MetricServiceProtocol = HeartRateService()) {
        self.service = service
    }
    //MARK: - Public API
    
    ///Loads Metrics Data Asynchronously
    
    func loadMetric() {
        isLoading = true
        ///Task is used to perform async work from a non-async context
        Task { [weak self] in
            
            guard let self else { return }
            
            ///Use 'defer' to ensure loading state  is always toggled off even if the task is cancelled or fails.
            defer {self.isLoading = false}
            
            self.metric = try? await service.fetchMetric()
            
        }
    }
    
}
