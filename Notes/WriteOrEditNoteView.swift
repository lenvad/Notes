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
	@State var isOn = false
	
	init(username: String, note: Note? = nil) {
        self.username = username
        self.note = note
    }

    var body: some View {
        NavigationView {
            VStack {
				if viewModel.errorMessage != "" {
					Text(viewModel.errorMessage)
						.errorMessageText(errorMessage: viewModel.errorMessage)
				}
				
				Divider().padding(.top)
				
				UITextViewRepresentable(
					text: $viewModel.noteText,
					isBold: $viewModel.isBold,
					isItalic: $viewModel.isItalic,
					isUnderlined: $viewModel.isUnderlined,
					fontSizeDouble: $viewModel.fontSizeDouble,
					fontSizeString: $viewModel.fontSizeString,
					selectedRange: $viewModel.selectedRange, 
					color: $viewModel.selectedColor,
					formattingCurrentlyChanged: $viewModel.formattingCurrentlyChanged
				)
					.autocorrectionDisabled()
					.disabled(viewModel.contentDisabled)
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
						
						Picker("Color", selection: $viewModel.selectedColor) {
							ForEach(viewModel.colorList, id: \.self) { value in
								Text(value).tag(value)
							}
						}.onChange(of: viewModel.selectedColor) {
							viewModel.formattingCurrentlyChanged = true
						}
						
						TextField("", text: $viewModel.fontSizeString)
							.onChange(of: viewModel.fontSizeString) {
								viewModel.onScreenEvent(.fontSizeChanged)
							}
							.font(.headline)
							.padding(10)
							.overlay(RoundedRectangle(cornerRadius: 5)
								.stroke(Color(.lightGray), lineWidth: 0.5))
                    }
                }
            }
		}.onAppear {
            viewModel.onScreenEvent(.onAppearance(note: note))
        }
    }
    
	func toolButton(imageName: String, backgroundColorOn : Bool, action: @escaping () -> Void) -> some View {
        return Button(action: {
            action()
        }, label: {
            Image(systemName: imageName).font(.system(size: 15))
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 10.0)
					.fill(backgroundColorOn ? Color("OrangeMain").opacity(0.3):.clear))
		})
    }
}

#Preview {
    WriteOrEditNoteView(username: "l")
}


