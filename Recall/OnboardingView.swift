//
//  OnboardingView.swift
//  Recall
//
//  Created by Fad Rahim on 13/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool

    let onboardingPages = [
        OnboardingPage(
            title: "Welcome to Recall",
            description: "Your personal space to capture and organize your thoughts, ideas, and memories.",
            systemImage: "brain.head.profile",
            color: .blue
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Keep everything in one place with powerful organization tools designed for iPad.",
            systemImage: "folder.fill",
            color: .purple
        ),
        OnboardingPage(
            title: "Access Anywhere",
            description: "Your notes sync seamlessly across all your devices, ready when you need them.",
            systemImage: "icloud.fill",
            color: .cyan
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    OnboardingPageView(page: onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(action: {
                if currentPage < onboardingPages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    isOnboardingComplete = true
                }
            }) {
                Text(currentPage < onboardingPages.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 400)
                    .padding()
                    .background(onboardingPages[currentPage].color)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)

            if currentPage < onboardingPages.count - 1 {
                Button("Skip") {
                    isOnboardingComplete = true
                }
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: page.systemImage)
                .font(.system(size: 120))
                .foregroundColor(page.color)

            Text(page.title)
                .font(.system(size: 42, weight: .bold))
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)

            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
