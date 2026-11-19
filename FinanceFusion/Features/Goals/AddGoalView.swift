import SwiftUI
import SwiftData
import PhotosUI

struct AddGoalView: View{
    @State private var viewModel = AddGoalViewModel()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        NavigationStack{
            Form{
                Section("Goal"){
                    TextField("Name (e.g. New car)", text: $viewModel.name)
                    TextField("Price", text: $viewModel.priceText).keyboardType(.decimalPad)
                    TextField("Saved so far (Optional)", text: $viewModel.savedText).keyboardType(.decimalPad)
                }
                Section("Image"){
                    PhotosPicker(selection: $viewModel.selectedImage, matching: .images){
                        Label(viewModel.selectedImage == nil ? "Choose a photo" : "Change photo", systemImage: "photo")
                    }
                }
                
                if let data = viewModel.imageData, let UIImage = UIImage(data: data) {
                    Image(uiImage: UIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .listRowInsets(EdgeInsets())
                        
                    Button("Remove photo", role: .destructive){
                        viewModel.removeImage()
                    }
                }
            }
            .onChange(of: viewModel.selectedImage){
                Task {await viewModel.loadImage()}
            }
            .navigationTitle("New goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){dismiss()}
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Save"){
                        viewModel.save(in: context)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    AddGoalView()
        .modelContainer(for: Goal.self, inMemory: true)
}
