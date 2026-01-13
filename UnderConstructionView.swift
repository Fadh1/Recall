//
//  UnderConstructionView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct UnderConstructionView: View {
    let subject: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "hammer.fill")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            Text("Under Construction")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(subject) content is coming soon!")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    UnderConstructionView(subject: "English")
}
