//
//  MarvelApp.swift
//  Marvel
//
//  Created by Aniket Patil on 22/05/24.
//

import SwiftUI

@main
struct MarvelApp: App {
    @StateObject private var homeData = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(homeData)
        }
    }
}
