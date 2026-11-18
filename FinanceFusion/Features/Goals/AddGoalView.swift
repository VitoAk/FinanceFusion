import SwiftUI
import SwiftData
import PhotosUI
import UIKit

@Observable //Enables SwiftUI to make changes to the values inside the class
final class AddGoalView{
    var name: String = ""
    var priceText: String = ""
    var savedText: String = ""
    var optDescription: String = ""
    var selectedImage: PhotosPickerItem?
    var imageData: Data?
    
    //Validation
    var price: Decimal? {Decimal(string: priceText, locale: .current)}
    var ammountSaved: Decimal? {Decimal(string: savedText, locale: .current)}
    
    var isValid: Bool{
        !name.trimmingCharacters(in: .whitespaces).isEmpty && (price ?? 0) > 0
    }
    
    //Image functions
    func loadImage() async{
        guard let item = selectedImage else{return}
        if let data = try? await item.loadTransferable(type: Data.self){ //load the image and save as Data type
            imageData = Self.downscaledJPEG(from: data)
        }
    }
    
    func removeImage(){
        selectedImage = nil
        imageData = nil
    }
    
    //Scale down the images so they take less storage
    private static func downscaledJPEG(from data: Data, maxDimension: CGFloat = 1200) -> Data? {
            guard let image = UIImage(data: data) else { return nil }
            let largest = max(image.size.width, image.size.height)
            let scale = min(1, maxDimension / largest)
            let newSize = CGSize(width: image.size.width * scale,
                                 height: image.size.height * scale)
            let resized = UIGraphicsImageRenderer(size: newSize).image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
            return resized.jpegData(compressionQuality: 0.8)
    }
    
    func save(in context: ModelContext){
        guard let price, isValid else {return}
        let goal = Goal(name: name.trimmingCharacters(in: .whitespaces),
                        targetAmount: price,
                        imageData: imageData)
        context.insert(goal)
        if let saved = ammountSaved, saved > 0{
            context.insert(Contribution(amount: saved, goal: goal))
        }
    }
}
