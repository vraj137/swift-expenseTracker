import SwiftUI

struct ContentView: View {
    @State private var expenseName = ""
    @State private var expenseAmount = ""
    @State private var expenses: [Expense] = []

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Expense name", text: $expenseName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        TextField("Amount", text: $expenseAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)
                        Button(action: addExpense) {
                            Text("Add")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.horizontal)
                    }
                    .padding(.bottom)

                    List {
                        Section(header: Text("View Your Expenses")) {
                            ForEach(expenses) { expense in
                                ExpenseRow(expense: expense)
                            }
                            .onDelete(perform: removeExpense)
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("Expenses")
                    .navigationBarItems(trailing: EditButton())
                    
                    Spacer()
                }
                .padding()
            }
            .tabItem {
                Label("Expenses", systemImage: "dollarsign.circle.fill")
            }
            
            NavigationView {
                VStack {
                    Text("This is where you can view your budget.")
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Budget")
            }
            .tabItem {
                Label("Budget", systemImage: "chart.pie.fill")
            }
            
            
            NavigationView {
                VStack {
                    Text("This is where you can analyze your expenses.")
                    
                    
                    Button(action: analyzeExpenses) {
                        Text("Analyze")
                            .fontWeight(.semibold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                            .navigationBarTitle("Analysis")
                        
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .tabItem {
                Label("Analysis", systemImage: "chart.bar.fill")
            }
        }
    }
    
    func addExpense() {
        guard let amount = Double(expenseAmount) else { return }
        let expense = Expense(name: expenseName, amount: amount)
        expenses.append(expense)
        expenseName = ""
        expenseAmount = ""
    }
    
    func removeExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
    
    func analyzeExpenses() {
        let total = expenses.reduce(0) { $0 + $1.amount }
        let average = total / Double(expenses.count)
        let highestExpense = expenses.max { $0.amount < $1.amount }
        
        let alert = UIAlertController(title: "Expense Analysis", message: "Total: $\(total)\nAverage: $\(average)\nHighest Expense: \(highestExpense?.name ?? "") - $\(highestExpense?.amount ?? 0)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack {
            Text(expense.name)
            Spacer()
            Text(String(format: "$%.2f", expense.amount))
        }
    }
}

struct Expense: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
