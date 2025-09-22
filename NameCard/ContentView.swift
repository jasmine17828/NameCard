//
//  ContentView.swift
//  NameCard
//
//  Created by Harry Ng on 9/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PeopleListView()
                .tabItem { Label("Directory", systemImage: "person.3") }

//            ManageView()
//                .tabItem { Label("Manage", systemImage: "tray.full") }
        }
    }
}

#Preview {
    ContentView()
}
