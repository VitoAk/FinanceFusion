import SwiftUI
import SwiftData

struct GoalsView: View{
    @Environment(\.modelContext) private var context
    @Query(sort: \Goal.createdAt, order: .reverse) private var goals: [Goal]
    
    @State private var showingAddGoal: Bool = false
    @State private var goalToAllocate: Goal?
    @State private var goalToDelete: Goal?
    
    var body: some View{
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 16){
                    ForEach(goals){goal in
                        NavigationLink(value: goal){
                            GoalCard(goal: goal){goalToAllocate = goal}
                        }
                        .buttonStyle(.plain)
                        .contextMenu{
                            Button("Delte Goal", systemImage: "trash", role: .destructive){
                                goalToDelete = goal
                            }
                        }
                    }
                }
                .padding()
            }
            .overlay{
                if goals.isEmpty{
                    ContentUnavailableView(
                        "No goals yet!",
                        systemImage: "target",
                        description: Text("Tap + to start a goal.")
                    )
                }
            }
            .navigationTitle("Goals")
            .navigationDestination(for: Goal.self){GoalDetailView(goal: $0)}
            .toolbar{
                Button("Add goal", systemImage: "plus"){showingAddGoal = true}
            }
            .sheet(isPresented: $showingAddGoal){AddGoalView()}
            .sheet(item: $goalToAllocate){ goal in
                AllocateSheet(goal: goal)
                    .presentationDetents([.medium])
            }
            .confirmationDialog(
                "Delete \(goalToDelete?.name ?? "goal")?",
                isPresented: Binding(get: {goalToDelete != nil},
                                     set: {if !$0 {goalToDelete = nil}}),
                titleVisibility: .visible
            ){
                Button("Delete", role: .destructive){
                    if let goalToDelete {context.delete(goalToDelete)}
                    goalToDelete = nil
                }
            } message:{
                Text("All contributions to this goal will be deleted too.")
            }
        }
    }
}

#Preview{
    GoalsView()
        .modelContainer(for: Goal.self, inMemory: true)
}
