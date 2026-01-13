//
//  HomeView.swift
//  Recall
//
//  Created by Fad Rahim on 13/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UnderConstructionView(subject: "English")
                .tabItem {
                    Label("English", systemImage: "book.fill")
                }
                .tag(0)
            
            UnderConstructionView(subject: "Malay")
                .tabItem {
                    Label("Malay", systemImage: "book.fill")
                }
                .tag(1)
            
            MathQuestionSetsListView()
                .tabItem {
                    Label("Math", systemImage: "function")
                }
                .tag(2)
            
            UnderConstructionView(subject: "POA")
                .tabItem {
                    Label("POA", systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            UnderConstructionView(subject: "Physics")
                .tabItem {
                    Label("Physics", systemImage: "atom")
                }
                .tag(4)
            
            UnderConstructionView(subject: "Chemistry")
                .tabItem {
                    Label("Chemistry", systemImage: "flask.fill")
                }
                .tag(5)
            
            UnderConstructionView(subject: "History")
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(6)
            
            UnderConstructionView(subject: "Social Studies")
                .tabItem {
                    Label("Social Studies", systemImage: "globe")
                }
                .tag(7)
        }
    }
}

#Preview {
    HomeView()
}
