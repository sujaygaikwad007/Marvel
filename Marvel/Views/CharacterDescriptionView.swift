import SwiftUI

struct CharacterDescriptionView: View {
    var character: CharactersModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                
                descViewImage
                description
                characterLinks
   
            }
            .navigationTitle("Information")
        }
    }
}


extension CharacterDescriptionView {
    
    private var descViewImage : some View{
        
        AsyncImage(url: URL(string: character.thumbnailURL)) { phase in
            
            if let image = phase.image {

                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .cornerRadius(8.0)
                    .scaleEffect(phase.image != nil ? 1.0 : 0.5)
                    .animation(.spring())
                
                
            } else if phase.error != nil {
                Color.red
                    .frame(width: 150, height: 150)
                    .clipShape(Rectangle())
                    .cornerRadius(8.0)
                    .padding(.vertical,10)
            } else {
                Color.gray
                    .frame(width: 150, height: 150)
                    .clipShape(Rectangle())
                    .cornerRadius(8.0)
                    .padding(.vertical,10)
            }
        }
     
    }
    
    private var description : some View{
        Text(character.description.isEmpty ? "No Description Available" : character.description)
            .font(.body)
            .foregroundColor(.black)
            .padding()
    }
    
    private var characterLinks : some View{
        HStack(spacing:10){
            ForEach(["detail", "wiki", "comiclink"], id: \.self) { type in
                if let url = character.url(forType: URLType(rawValue: type)!) {
                    NavigationLink(destination: WebView(urlString: url)) {
                        Text(type.capitalized)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .animation(.easeInOut)
                    }
                }
            }
        }
    }
    
}
