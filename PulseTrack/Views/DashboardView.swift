//
//  DashboardView.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import SwiftUI

//MARK: Responsible for only Displaying UI & forwarding User Actions

struct DashboardView: View {
    /// @StateObject  ensures that the viewModel is created Once.
    @StateObject private var viewModel: DashboardViewModel = DashboardViewModel()
    
    var body: some View {
        VStack( spacing: 20){
            
            ///Loading indicator
            if viewModel.isLoading{
                ProgressView()
                Text("Updating Metrics")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ///Error State
            if let error = viewModel.error{
                VStack(spacing:8){
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry"){
                        viewModel.loadMetric()
                    }
                }
            }
            
            ///Empty State
            if !viewModel.isLoading,
               viewModel.metrics.isEmpty,
               viewModel.error == nil {
                
                Text("no metric available")
                    .foregroundStyle(.secondary)
            }
            
        
                ///Metric Display
                ForEach(viewModel.metrics, id:\.id){ metric in
                    
                    VStack(spacing: 4){
                        Text(metric.name)
                            .font(.headline)
                        
                        Text(metric.value)
                            .font(.largeTitle)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            
            
            
            ///Refresh Button
            if !viewModel.isLoading{
                Button("Refresh"){
                    viewModel.loadMetric()
                }
            }
            
            
        }
        .padding()
        .onAppear{
            ///Load Data when the view Appears
            viewModel.loadMetric()
        }
        .onDisappear(){
            /// Cancel background Tasks when no longer needed
            viewModel.cancelLoading()
        }
    }
}

#Preview {
    DashboardView()
}
