import SwiftUI

struct comicRowView: View {
    var comic: ComicModel
    @State private var showAnimation = false 

    var body: some View {
        
        ZStack {
            HStack(alignment: .top, spacing: 15) {
                comicImage

                VStack(alignment: .leading, spacing: 8) {
                    comicTitle
                    comicDescription
                    comicLinks
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
            .animation(.easeInOut)
        }
        .padding(.horizontal)
        .onAppear {
            showAnimation = true
        }
    }
}

extension comicRowView {
    
    
    // Comic image
    private var comicImage: some View {
        
        AsyncImage(url: URL(string: comic.thumbnailURL)) { phase in
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(8.0)
                    .padding(.vertical,10)
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

    // Comic title
    private var comicTitle: some View {
        Text(comic.title)
            .font(.headline)
            .fontWeight(.semibold)
    }

    // Comic description
    private var comicDescription: some View {
        
        if let description = comic.description, !description.isEmpty {
            return Text(description)
                .font(.caption)
                .foregroundColor(Color.gray)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        } else {
            return Text("No Description Available")
                .font(.caption)
                .foregroundColor(Color.gray)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
    }

    // Comic links
    private var comicLinks: some View {
        HStack(spacing: 20) {
            ForEach(["detail", "wiki", "comiclink"], id: \.self) { type in
                if let url = comic.url(forType: URLComicType(rawValue: type)!) {
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
