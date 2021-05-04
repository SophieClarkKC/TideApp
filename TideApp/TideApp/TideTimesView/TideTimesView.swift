//
//  TideTimesView.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import SwiftUI
import Combine

struct TideTimesView: View {
    @ObservedObject var viewModel: TideTimesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            TitleLabel(text: viewModel.locationName).accessibility(label: Text("You are looking at tide times for \(viewModel.locationName)")).padding(EdgeInsets(top: PaddingValues.small, leading: 0, bottom: PaddingValues.small, trailing: 0))
            SubtitleLabel(text: viewModel.subTitle).padding(EdgeInsets(top: PaddingValues.small, leading: 0, bottom: PaddingValues.small, trailing: 0))
            ForEach(viewModel.tideTimes) { tideTime in
                BodyLabel(text: tideTime.tideTime)
            }
            SubtitleLabel(text: viewModel.tideHeight).padding(EdgeInsets(top: PaddingValues.small, leading: 0, bottom: PaddingValues.small, trailing: 0))
        })
        .padding(PaddingValues.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.backgroundColor.ignoresSafeArea(.all, edges: .top))
        
    }
}

struct TideTimesView_Previews: PreviewProvider {
    static var previews: some View {
        TideTimesView(viewModel: TideTimesViewModel())
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDevice("iPhone 12 Pro")
            
    }
}
