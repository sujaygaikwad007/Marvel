import SwiftUI

struct ComicsView: View {
    @EnvironmentObject var homeData: HomeViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if let fetchedComics = homeData.fetchedComics {
                    if fetchedComics.isEmpty {
                        ProgressView()
                            .padding(.top, 30)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(fetchedComics) { comic in
                                comicRowView(comic: comic)
                            }
                        }
                        .padding(.bottom)
                    }
                } else {
                    ProgressView()
                        .padding(.top, 30)
                }
            }
            .navigationTitle("Marvel's Comics")
        }
        .onAppear {
            if homeData.fetchedComics == nil {
                homeData.fetchComics()
            }
        }
    }
}
