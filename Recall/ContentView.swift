//
//  ContentView.swift
//  Recall
//
//  Created by Fad Rahim on 13/11/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    ContentView()
}
