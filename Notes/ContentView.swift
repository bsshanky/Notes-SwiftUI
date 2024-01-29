//
//  ContentView.swift
//  Notes
//
//  Created by Shashank  on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel

    var body: some View {
        
        Group {
            if notesViewModel.isDataLoaded {
                NotesView()
            } else {
                ProgressView("Loading...")
            }
        }
    }
}
