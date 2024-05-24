import SwiftUI

struct CharacterDescriptionView: View {
    var character: CharactersModel
    
    var body: some View {
        ZStack {
            VStack() {
                
                descViewImage
                description
                characterLinks
   
            }
            .navigationTitle("Information")
        }
    }
}

extension CharacterDescriptionView {
    
    private var descViewImage: some View {
        
        AsyncImage(url: URL(string: character.thumbnailURL)) { phase in
            
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .cornerRadius(8.0)
                    .opacity(1.0)
                    .animation(.easeInOut(duration: 1.0), value: phase.image != nil)
                
            } else if phase.error != nil {
                Color.red
                    .frame(width: 150, height: 150)
                    .clipShape(Rectangle())
                    .cornerRadius(8.0)
                    .padding(.vertical, 10)
                    .opacity(1.0)
                    .animation(.easeInOut(duration: 1.0), value: phase.error != nil)
            } else {
                Color.gray
                    .frame(width: 150, height: 150)
                    .clipShape(Rectangle())
                    .cornerRadius(8.0)
                    .padding(.vertical, 10)
                    .opacity(1.0)
                    .animation(.easeInOut(duration: 1.0), value: phase.image == nil)
            }
        }
    }
    
    private var description: some View {
        Text(character.description.isEmpty ? "No Description Available" : character.description)
            .font(.body)
            .foregroundColor(.black)
            .padding()
            .opacity(1.0)
            .animation(.easeInOut(duration: 1.0), value: character.description.isEmpty)
    }
    
    private var characterLinks: some View {
        HStack(spacing: 10) {
            ForEach(["detail", "wiki", "comiclink"], id: \.self) { type in
                if let url = character.url(forType: URLType(rawValue: type)!) {
                    NavigationLink(destination: WebView(urlString: url)) {
                        Text(type.capitalized)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .opacity(1.0)
                            .animation(.easeInOut(duration: 0.5), value: url)
                    }
                }
            }
        }
    }
}
