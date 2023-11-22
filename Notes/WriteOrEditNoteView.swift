//
//  WriteOrEditNoteView.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import SwiftUI

struct WriteOrEditNoteView: View {
    @StateObject var viewModel = WriteOrEditNoteViewModel()
    var user: User
    var note: Note?
    
    
    init(user: User, note: Note? = nil) {
        self.user = user
        self.note = note
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.contentDisabled {
                    Divider().padding(.top)
                }

                TextEditor(text: $viewModel.content)
                    .padding(15)
                    .disabled(viewModel.contentDisabled)

                if !viewModel.contentDisabled {
                    Divider()
                }
            }
            .toolbar {
                /*
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: NotesListView(username: user.username!).navigationBarBackButtonHidden(true)){
                        HStack {
                            //Label("Back", systemImage: chevron.backward)
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
                 */
                if viewModel.contentDisabled {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.contentDisabled = false
                        }, label: {
                            Image(systemName: "pencil.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(15)
                        })
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

                if !viewModel.contentDisabled {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.onScreenEvent(.addOrUpdateNote(inputUser: user))
                        }, label: {
                            Text("Save")
                        })
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        toolButton(imageName: "list.bullet")
                        toolButton(imageName: "pencil.tip")
                        toolButton(imageName: "ruler.fill")
                    }
                }
            }
        }
        .onAppear {
            viewModel.onScreenEvent(.onAppearance(note: note, user: user))
        }
    }
    
    func toolButton(imageName: String) -> some View {
        return Button(action: {
            // Handle button action
        }, label: {
            Image(systemName: imageName).font(.system(size: 20))
        })
    }
}

 /*
#Preview {
    WriteOrEditNoteView()
}

*/
