import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImageUploadView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var filteredImage: UIImage?
    
    var body: some View {
        VStack {
            CustomBackButton() {
                dismiss()
            }
            Spacer()
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            if let filteredImage = filteredImage {
                Image(uiImage: filteredImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            Button {
                isShowingImagePicker = true
            } label: {
                CustomText(
                    text: "Select an image",
                    textSize: 16,
                    color: Colors.primary
                ).bold()
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            CustomButtonWithAction(
                title:  "Apply the machine",
                action: {
                    if let image = selectedImage {
                        filteredImage = MetalImageFilter()?.applyFilter(to: image)
                    }
                })
            .padding()
            .navigationBarBackButtonHidden()
            Spacer()
        }.background(.white)
    }
}
