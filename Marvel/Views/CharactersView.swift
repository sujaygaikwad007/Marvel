

import SwiftUI

struct CharactersView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                
                    searchBar
                    
                }
                .padding()
                
                if let character = homeData.fetchedCharacter {
                    
                    if character.isEmpty{
                        Text("No Results")
                            .padding(.top,20)
                    }
                    else{
                        ForEach(character){ data in
                            CharacterRowView(character: data)
                            
                        }
                    }
                    
                }
                else{
                    if homeData.searchQuery  != ""{
                        ProgressView()
                            .padding(.top,20)
                    }
                }
                
            }
            .navigationTitle("Marvel")
        }
    }
    
    
}


extension CharactersView {
    
    private var searchBar : some View {
        
        HStack(spacing:10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Character....",text: $homeData.searchQuery)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
        }
    }
    
}

