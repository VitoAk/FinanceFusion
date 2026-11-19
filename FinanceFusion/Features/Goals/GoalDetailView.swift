import SwiftUI
import SwiftData

struct GoalDetailView: View{
    let goal: Goal
    @Environment(\.modelContext) private var context
    @State private var showingAllocate: Bool = false

    private var history: [Contribution]{
        goal.contributions.sorted{$0.date > $1.date}
    }
    
    var body: some View{
        List{
            Section{
                GoalCard(goal: goal){showingAllocate = true}
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            
            Section("History"){
                if history.isEmpty{
                    Text("No contributions yet!").foregroundStyle(Color.blue)
                }
                ForEach(history){ contribution in
                    HStack{
                        Text(contribution.date, format: .dateTime.day().month().year())
                        Spacer()
                        Text("+\(contribution.amount.asCurrency)")
                            .bold()
                            .foregroundStyle(Color.green)
                    }
                }
                .onDelete{ offsets in
                    for index in offsets {context.delete(history[index])}
                }
            }
        }
        .navigationTitle(goal.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAllocate){
            AllocateSheet(goal: goal)
                .presentationDetents([.medium])
        }
    }
}
