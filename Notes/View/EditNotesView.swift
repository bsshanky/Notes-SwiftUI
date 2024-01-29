//
//  EditNotesView.swift
//  Notes
//
//  Created by Shashank  on 1/27/24.
//

import SwiftUI

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    
    @State var note: NoteEntity?
    @State private var title: String = ""
    @State private var content: String = ""
    
    @FocusState private var contentEditorInFocus: Bool

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                                
                TextField("Title", text: $title, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .onChange(of: title, {
                        guard let newValueLastChar = title.last else { return }
                        if newValueLastChar == "\n" {
                            title.removeLast()
                            contentEditorInFocus = true
                        }
                    })
                    
                TextEditorView(string: $content)
                    .scrollDisabled(true)
                    .font(.title3)
                .focused($contentEditorInFocus)
                
    
            }
            .padding(10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        self.hideKeyboard()
                        // Save to Core Data
                        self.updateNote(title: title, content: content)
                    }
                }
            }
        }
        .onAppear {
            
            if let note = note {
                self.title = note.title ?? ""
                self.content = note.content ?? ""
            }
        }
                    
    }
    
    // MARK: Core Data Operations

    func updateNote(title: String, content: String) {
        
        if (title.isEmpty) && (content.isEmpty) {
            return
        }
        
        guard let note = note else { return }
        
        vm.updateNote(note, title: title, content: content)
    }
}
