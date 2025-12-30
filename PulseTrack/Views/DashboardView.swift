//
//  DashboardView.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import SwiftUI

//MARK: Responsible for only Displaying UI & forwarding User Actions
struct DashboardView: View {
    //MARK: - State
    
    /// @StateObject  ensures that the viewModel is created Once.
    @StateObject private var viewModel: DashboardViewModel = DashboardViewModel()
    
    var body: some View {
        VStack( spacing: 20){
            
            ///Loading indicator
            if viewModel.isLoading{
                ProgressView()
            }
            
            ///Metric Display
            if let metric = viewModel.metric{
                
                Text(metric.name)
                    .font(.headline)
                
                Text(metric.value)
                    .font(.largeTitle)
            }
            
            ///Refresh Button
            Button("Refresh"){
                viewModel.loadMetric()
            }
        }
        .padding()
        .onAppear{
            ///Load Data when the view Appears
            viewModel.loadMetric()
        }
    }
}

#Preview {
    DashboardView()
}
