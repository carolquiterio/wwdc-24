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
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var filteredImage: UIImage?
    @State private var selectedImageIndex = 0
    let imageNames = ["ExampleImage1", "ExampleImage2", "ExampleImage3", "Semaphore", "ExampleImage4", "ExampleImage5", "ExampleImage6"]
    
    var body: some View {
        VStack {
            if #available(iOS 17, *) {
                VStack {
                    CustomText(text: "Select an image below or use the + button the add an image from your photo galery.", textSize: 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 12) {
                            ForEach(0..<imageNames.count, id: \.self) { index in
                                Button(action : {
                                    selectedImage = UIImage(named: imageNames[index] )
                                }) {
                                    Image(imageNames[index])
                                        .resizable()
                                        .scaledToFit()
                                        .tag(index)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }.frame(maxHeight: 100)
                        .padding().scrollDisabled(false)
                }
                Spacer()
                if let filteredImage = filteredImage {
                    Image(uiImage: filteredImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 400).colorEffect(ShaderLibrary.addShapes(.boundingRect))
                }
                Spacer()
                
                Button(action: {
                    if let image = selectedImage {
                        filteredImage = image
                    } else if(selectedImageIndex != 0) {
                        filteredImage = UIImage( named:  imageNames[selectedImageIndex])
                    }
                }) {
                    HStack {
                        CustomBoldText(
                            text: "Apply the machine",
                            textSize: 18,
                            color: .white
                        )
                    }
                    .frame(maxWidth: 285, maxHeight: 30)
                    .padding()
                    .background(selectedImage != nil ? Colors.primary : Color.clear)
                    .cornerRadius(40)
                    
                }.disabled(selectedImage == nil)
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Images")
                .navigationBarItems(trailing : Image(systemName: "plus")
                    .foregroundColor(Colors.primary)
                                    
                    .font(.system(size: 20)).onTapGesture {
                        isShowingImagePicker = true
                    }).sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
            }
            else {
                Spacer()
                CustomText(text: "You need to be in iOS 17 use this feature.", textSize: 16).padding()
                Spacer()
                    .navigationTitle("Images")
            }
        }.background(.white)
    }
}

#Preview {
    ImageUploadView()
}
