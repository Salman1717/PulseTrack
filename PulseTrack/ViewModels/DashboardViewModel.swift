//
//  DashboardViewModel.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation
import Combine

//MARK: Dashboard ViewModel

// Handles:
/// - Business logic
/// - Async operations
/// - Error States
/// - Delegate data saftey to  an actor

// Annoted with @MainActor to ensure UI state updates happen on main thread

@MainActor
final class DashboardViewModel: ObservableObject{
    
    //MARK: -  Published States
    
    ///List of  Metrics  Displayed on dashboard
    @Published private(set) var metrics: [Metric] = []
    
    ///Controls Loading State in the UI
    @Published var isLoading: Bool = false
    
    /// Error
    @Published var error: AppError?
    
    //MARK: - Dependencies
    
    ///Avoid unsafe assumptions and instead ensure dependencies are initialized within the actor context using lazy properties or initializer bodies
    ///as our viewModel  runs on  @MainActor
    ///Lazy initialization ensures dependencies are created inside the actor context only when needed, which avoids isolation warnings and improves startup performance
    ///Use lazy dependency initialization to ensure actor-safe construction without sacrificing testability or architecture.
    
    ///Service Injected to fetch metric data
    private lazy var heartRateService: MetricServiceProtocol = HeartRateService()
    private lazy var stepsService: MetricServiceProtocol = StepsService()
    
    //MARK: - Actor
    
    /// Actor responsible for safely storing metrics
    private let metricStore = MetricStore()
    
    // MARK: - Task Management
    ///We keep a reference to the async Task so I can explicitly cancel it when it’s no longer needed
    
    ///Refrence to the current async task
    private var loadTask: Task<Void, Never>?
    
    
    //MARK: - Public API
    
    ///Loads Metrics Data Asynchronously
    func loadMetric() {
        
        ///Cancel any existing task before starting a new one
        loadTask?.cancel()
        
        isLoading = true
        ///Task is used to perform async work from a non-async context
        loadTask = Task { [weak self] in
            
            guard let self else { return }
            
            ///Use 'defer' to ensure loading state  is always toggled off even if the task is cancelled or fails.
            defer {self.isLoading = false}
            
            //exit early if task was cancelled
            guard !Task.isCancelled else { return }
            
            
            do{
                /// Fetch Metrics  concurrently
                async let heartRate = heartRateService.fetchMetric()
                async let steps = stepsService.fetchMetric()
                
                let fetchedMetrics = try await [heartRate, steps]
                
                /// Actor  handles shared state safely
                await metricStore.set(fetchedMetrics)
                
                ///UI  Reads actor-protected data
                self.metrics = await metricStore.get()
                
            }catch{
                await metricStore.clear()
                self.metrics = []
                self.error = .failedToLoad
            }
            
        }
    }
    
    //Cancel loading
    func cancelLoading(){
        loadTask?.cancel()
        loadTask = nil
        isLoading = false
    }
    
}
