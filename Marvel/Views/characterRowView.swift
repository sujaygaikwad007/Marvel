import SwiftUI

struct characterRowView: View {
    
    var character: CharactersModel
    @State private var showAnimation = false
    
    var body: some View {
        
        ZStack {
            
            HStack(alignment: .top, spacing: 15) {
                
                characterImage
                
                VStack(alignment:.leading, spacing: 8) {

                    characterTitle
                    characterDescription
                    characterLinks
                }
                .padding(.vertical)
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .offset(x: showAnimation ? 0 : -50)
            .opacity(showAnimation ? 1 : 0)
            .animation(.easeInOut(duration: 0.5))
            
        }
        .padding(.horizontal)
        .onAppear {
            showAnimation = true
        }
        
    }
    
    
}

extension characterRowView {
    
    //Character image
    private var characterImage : some View {
        
        AsyncImage(url: URL(string: character.thumbnailURL)) { phase in
            
            if let image = phase.image {
                
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(8.0)
                    .padding(.vertical,10)
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
    
    //Character Title
    private var characterTitle : some View {
        Text(character.name)
            .font(.headline)
            .fontWeight(.semibold)
    }
    
    // Character Description
    private var characterDescription: some View {
        if character.description.isEmpty {
            return Text("No Description Available")
                .font(.caption)
                .foregroundColor(Color.gray)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        } else {
            return Text(character.description)
                .font(.caption)
                .foregroundColor(Color.gray)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
    }
    
//    //Character Links
    private var characterLinks : some View{

        HStack(spacing:10){
            ForEach(["detail", "wiki", "comiclink"], id: \.self) { type in
                if let url = character.url(forType: URLType(rawValue: type)!) {
                    NavigationLink(destination: WebView(urlString: url)) {
                        Text(type.capitalized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .animation(.easeInOut)
                    }
                }
            }
        }
    }
    
  
}


