import SwiftUI
import SwiftData

struct AllocateSheet: View{
    let goal: Goal
    @State private var viewModel = AllocateViewModel()
    @FocusState private var amountFocused: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    private let quickAmounts: [Decimal] = [10, 25, 50, 100, 250]
    
    var body: some View{
        NavigationStack{
            Form{
                Section("Add to \(goal.name)"){
                    TextField("Amount", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                        .focused($amountFocused)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(quickAmounts, id: \.self){ value in
                                Button("+\(value.asCurrency)"){
                                    viewModel.setQuick(value)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                Section{
                    LabeledContent("Saved so far: ", value: goal.savedAmount.asCurrency)
                    LabeledContent("Remaining: ", value: goal.remainingAmount.asCurrency)
                }
                .navigationTitle("Allocate")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){dismiss()}
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button("Save"){
                            viewModel.save(to: goal, in: context)
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isValid)
            }
        }
        .onAppear{amountFocused = true}
    }
}
