

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var messages: [String] = ["Hello! How can I assist you today?"]
    @State private var userInput: String = ""
    @State var showMenu : Bool = false
    @State private var selectedOption : String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Message.timestamp, ascending: true)],
        animation: .default
    )
    
    private var message : FetchedResults<Message>
    
    private func clearMessages() {
            messages = []
    }
    
    func appendMessageWithTypingEffect(response: String) {
        var currentMessage = ""
    
        for (index, character) in response.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0005 * Double(index)) {
                currentMessage.append(character)
                    self.messages[self.messages.count - 1] = currentMessage
                
            }
        }
    }
    
    func saveArray(){
        let newMessage = Message(context: viewContext)
        newMessage.timestamp = Date()
        newMessage.items = messages as NSObject

        do {
            try viewContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }

    
    func fetchMessages(context :NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        
        do{
            let msgs = try context.fetch(fetchRequest)
            var newMsg : [String] = []
            for message in msgs{
                if let items = message.items as? [String]{
                    newMsg.append( contentsOf: items)
                }
            }
            DispatchQueue.main.async{
                self.messages = newMsg
                print(newMsg)
            }
        }catch{
            print("Failed to fetch")
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button( action :{
                        showMenu.toggle()
                    }){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                    
                    if showMenu {
                        VStack(spacing: 10) {
                            Button("Edit Profile Photo") {
                                selectedOption = "Edit Profile Photo"
                                showMenu = false // Hide the menu after selection
                            }
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("See History") {
                                selectedOption = "See History"
                                showMenu = false // Hide the menu after selection
                            }
                            .padding()
                            .background(Color.green.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Create New Chat") {
                                selectedOption = "New Chat"
                                showMenu = false // Hide the menu after selection
                                clearMessages()
                            }
                            .padding()
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    
                    if selectedOption == "New Chat"{
                        
                    }
                    Text("Vedanta")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                    //                    .navigationTitle("Chat")
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages, id: \.self) { message in
                            HStack {
                                if message.contains("User:") {
                                    Text(message.replacingOccurrences(of: "User:", with: ""))
                                        .padding()
                                        .background(Color.blue.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    Text(message.replacingOccurrences(of: "Bot:", with: ""))
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding()
                }

                // Input Section
                HStack {
                    TextField("Type your message...", text: $userInput)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                        .autocorrectionDisabled()

                    Button(action: {
                        if !userInput.isEmpty {
                            messages.append("User: \(userInput)")
                            saveArray()

                            NetworkManager.shared.getChatbotResponse(inputText: userInput) { response in
                                    self.messages.append(userInput)
                                    self.messages.append("")
                                    if let response = response {
                                              self.appendMessageWithTypingEffect(response: response)
                                          } else {
                                              // If there's no response, print default message
                                              self.appendMessageWithTypingEffect(response: "No response, it's default")
                                    }
                                
                        }

                            userInput = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        .onAppear{
//            fetchMessages(context: viewContext)
        }
    }

   
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
