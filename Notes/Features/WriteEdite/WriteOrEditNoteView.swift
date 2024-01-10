//
//  WriteOrEditNoteView.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//
import SwiftUI

struct WriteOrEditNoteView: View {
	@StateObject var viewModel: WriteOrEditNoteViewModel

    var body: some View {
        NavigationView {
            VStack {
				if viewModel.errorMessage != "" {
					Text(viewModel.errorMessage)
						.errorMessageText(errorMessage: viewModel.errorMessage)
				}
				
				Divider().padding(.top)
				
				UITextViewRepresentable(
					text: viewModel.noteText,
					isBold: $viewModel.isBold,
					isItalic: $viewModel.isItalic,
					isUnderlined: $viewModel.isUnderlined,
					checklistActivated: $viewModel.checklistActivated,
					fontSizeDouble: $viewModel.fontSizeDouble,
					fontSizeString: $viewModel.fontSizeString,
					selectedRange: $viewModel.selectedRange, 
					color: $viewModel.selectedColor,
					formattingCurrentlyChanged: $viewModel.formattingCurrentlyChanged,
					onUpdate: { event in
						switch event {
						case .text(let newValue):
							viewModel.noteText = newValue
						case .isBold(let newValue):
								break
							//viewModel.isBold = newValue
						case .isItalic(let newValue):
								break
							//viewModel.isItalic = newValue
						}
					}
				)
					.autocorrectionDisabled()
					.disabled(viewModel.contentDisabled)
                if !viewModel.contentDisabled {
					Divider().padding(.bottom)
                }
            }
			.toolbar(content: {
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
							viewModel.onScreenEvent(.addOrUpdateNote)
						}, label: {
							Text("Save")
						}).padding(.trailing)
					}

					ToolbarItemGroup(placement: .bottomBar) {
						toolButton(imageName: "bold",
								   backgroundColorOn: viewModel.isBold,
								   fontsize: 19,
								   action: {
							viewModel.onScreenEvent(.toolbarButtons(event: .bold))
						})

						toolButton(imageName: "italic",
								   backgroundColorOn: viewModel.isItalic,
								   fontsize: 19,
								   action: {
							viewModel.onScreenEvent(.toolbarButtons(event: .italic))
						})

						toolButton(imageName: "underline",
								   backgroundColorOn: viewModel.isUnderlined,
								   fontsize: 17,
								   action: {
							viewModel.onScreenEvent(.toolbarButtons(event: .underlined))
						})

						toolButton(imageName: "checklist",
								   backgroundColorOn: viewModel.checklistActivated,
								   fontsize: 15,
								   action: {
							viewModel.onScreenEvent(.toolbarButtons(event: .checklist))
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
			})
		}.onAppear {
            viewModel.onScreenEvent(.onAppearance)
        }
    }
    
	private func toolButton(imageName: String, backgroundColorOn: Bool, fontsize: Double, action: @escaping () -> Void) -> some View {
        return Button(action: {
            action()
        }, label: {
            Image(systemName: imageName).font(.system(size: fontsize))
				.padding(5)
				.overlay(RoundedRectangle(cornerRadius: 5.0)
					.fill(backgroundColorOn ? Color(.orangeMain).opacity(0.3):.clear)
					.frame(width: 35, height: 35)
				)
		})
    }
}

struct WriteOrEditNoteView_Previews: PreviewProvider {
	static var previews: some View {
		WriteOrEditNoteView(viewModel: WriteOrEditNoteViewModel(username: "l"))
	}
}
