//
//  WriteOrEditNoteView.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import SwiftUI

struct WriteOrEditNoteView: View {
    @StateObject var viewModel = WriteOrEditNoteViewModel()
	var username: String
    var note: Note?
	@State var text: NSAttributedString = NSAttributedString(string: "")
	@State var selectedRange: NSRange = NSRange(location: 0, length: 0)

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
				
				UITextViewRepresentable(text: $text, isBold: $viewModel.isBold, isItalic: $viewModel.isItalic, selectedRange: $selectedRange)
					.disabled(viewModel.contentDisabled)
				/*
                TextEditor(text: $viewModel.content)
                    .padding(15)
                    .disabled(viewModel.contentDisabled)
					.bold(viewModel.isBold)
					.italic(viewModel.isItalic)
					.underline(viewModel.isUnderlined)
*/
                if !viewModel.contentDisabled {
					Divider().padding(.bottom)
                }
            }
            .toolbar {
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
						toolButton(imageName: "bold",
								   backgroundColorOn: viewModel.isBold,
								   action: {
							viewModel.onScreenEvent(.fontAdjustment(event: .bold))
						})
						toolButton(imageName: "italic",
								   backgroundColorOn: viewModel.isItalic,
								   action: {
							viewModel.onScreenEvent(.fontAdjustment(event: .italic))
						})
						toolButton(imageName: "underline",
								   backgroundColorOn: viewModel.isUnderlined,
								   action: {
							viewModel.onScreenEvent(.fontAdjustment(event: .underlined))
						})
						toolButton(imageName: "highlighter",
								   backgroundColorOn: false,
								   action: {
							
						})
                    }
                }
            }
		}
        .onAppear {
            viewModel.onScreenEvent(.onAppearance(note: note))
        }
    }
    
	func toolButton(imageName: String, backgroundColorOn : Bool, action: @escaping () -> Void) -> some View {
        return Button(action: {
            action()
        }, label: {
            Image(systemName: imageName).font(.system(size: 20))
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 10.0)
					.fill(backgroundColorOn == true ? Color("Orange").opacity(0.3):.clear))

		})
    }
}

#Preview {
    WriteOrEditNoteView(username: "l")
}


