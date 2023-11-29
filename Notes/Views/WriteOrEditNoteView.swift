//
//  WriteOrEditNoteView.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import SwiftUI
import PencilKit

struct WriteOrEditNoteView: View {
	//@Binding var canvasView: PKCanvasView
	
    @StateObject var viewModel = WriteOrEditNoteViewModel()
	var username: String
    var note: Note?
    
	init(username: String, note: Note? = nil) {
        self.username = username
        self.note = note
    }

    var body: some View {
        NavigationView {
            VStack {
				if(viewModel.errorMessage != "") {
					Text(viewModel.errorMessage)
						.errorMessageText(errorMessage: viewModel.errorMessage)
				}
				
				Divider().padding(.top)

                TextEditor(text: $viewModel.content)
                    .padding(15)
                    .disabled(viewModel.contentDisabled)

                if !viewModel.contentDisabled {
                    Divider()
                }
            }
            .toolbar {
<<<<<<< HEAD:Notes/WriteOrEditNoteView.swift
=======
                /*
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: NotesListView(username: user.username!).navigationBarBackButtonHidden(true)) {
                        HStack {
                            //Label("Back", systemImage: chevron.backward)
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
                 */
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/Views/WriteOrEditNoteView.swift
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
                            viewModel.onScreenEvent(.addOrUpdateNote(inputUsername: username))
                        }, label: {
                            Text("Save")
						}).padding(.trailing)
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
            viewModel.onScreenEvent(.onAppearance(note: note))
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
<<<<<<< HEAD:Notes/WriteOrEditNoteView.swift
/*
extension WriteOrEditNoteView: UIViewRepresentable {
	func makeUIView(context: Context) -> PKCanvasView {
		canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
		#if targetEnvironment(simulator)
		canvasView.drawingPolicy = .anyInput
		#endif
		return canvasView
	}
	
	func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
*/
=======

 /*
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/Views/WriteOrEditNoteView.swift
#Preview {
    WriteOrEditNoteView(username: "l")
}

<<<<<<< HEAD:Notes/WriteOrEditNoteView.swift

=======
*/
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/Views/WriteOrEditNoteView.swift
