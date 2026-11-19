import SwiftUI

struct GoalCard: View{
    let goal: Goal
    let onAllocate: () -> Void
    
    var body: some View{
        VStack(alignment: .leading, spacing: 12){
            if let data = goal.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            HStack{
                Text(goal.name).font(.headline)
                Spacer()
                Text(goal.targetAmount.asCurrency)
                    .foregroundStyle(Color(.systemBlue))
            }
            ProgressView(value: goal.progress)
                .tint(goal.isReached ? .green : .gray)
                .animation(.easeInOut, value: goal.progress)
            HStack{
                Text("\(goal.savedAmount.asCurrency) saved")
                Spacer()
                Text("\(Int(goal.progress * 100))% completed").bold()
            }
            .font(.subheadline)
            if goal.isReached{
                Label("Goal Reached!", systemImage: "checkmark.square.fill")
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
            }
            else{
                Button(action: onAllocate){
                    Label("Allocate money", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
    }
}
