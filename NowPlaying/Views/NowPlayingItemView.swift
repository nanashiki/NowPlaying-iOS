//
//  NowPlayingItemView.swift
//  NowPlaying
//
//  Created by beta on 2019/09/22.
//  Copyright © 2019 noppelab. All rights reserved.
//

import SwiftUI
import Combine

enum Feed {}

extension Feed {
    struct Content: Identifiable {
        let id: String
        let image: UIImage
        let title: String
        let artistName: String
    }
}

extension Feed {
    struct ItemOverlayContentView: View {
        let title: String
        let artistName: String
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "waveform")
                    Text(title).font(.title)
                }
                Text(artistName).font(.subheadline)
            }.padding().foregroundColor(.white)
        }
    }
}

extension Feed {
    struct ItemOverlayView: View {
        let title: String
        let artistName: String
        let gradient: Gradient = .init(colors: [.clear, Color.black.opacity(0.5)])
        let startPoint: UnitPoint = .init(x: 0, y: 0.5)
        let endPoint: UnitPoint = .init(x: 0, y: 1)
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
                Feed.ItemOverlayContentView(title: title, artistName: artistName)
            }.frame(maxWidth: .infinity)
        }
    }
}

extension Feed {
    struct ItemView: View {
        
        let image: UIImage
        let title: String
        let artistName: String
        let didTap: () -> Void
        
        var body: some View {
            VStack {
                Button(action: {
                    self.didTap()
                }) {
                    Image(uiImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(Feed.ItemOverlayView(title: title, artistName: artistName), alignment: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 10)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}


extension Feed {
    struct ContentView: View {
        @Binding var contents: [Content]
        @Binding var isPlaying: Bool
        @Binding var playingTitle: String
        let onTapSkipButton: () -> Void
        let onTapPlayButton: () -> Void
        let onTapPauseButton: () -> Void
        
        @State(initialValue: false) private var showingSheet: Bool
        @State(initialValue: nil) private var selectedContent: Content?
        
        var body: some View {
            NavigationView {
                ZStack(alignment: .bottom) {
                    List {
                        if contents.isEmpty {
                            NoticeView()
                        } else {
                            ForEach(contents, id: \.id) { (content) in
                                Feed.ItemView(image: content.image,
                                title: content.title,
                                artistName: content.artistName,
                                didTap: {
                                    self.selectedContent = content
                                    self.showingSheet = true
                                })
                            }
                        }
                    }
                    
                    PlayerControlView(isPlaying: $isPlaying,
                                      title: $playingTitle,
                                      onTapSkipButton: onTapSkipButton,
                                      onTapPlayButton: onTapPlayButton,
                                      onTapPauseButton: onTapPauseButton)
                }.navigationBarTitle("Now Playing")
                    .sheet(isPresented: $showingSheet) {
                    ActivityView(activityItems: ["♪ \(self.selectedContent!.title) / \(self.selectedContent!.artistName) #nowplaying", self.selectedContent!.image], applicationActivities: nil)
                }
            }
        }
    }
}

struct Feed_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Feed.ContentView(contents: .constant([
            Feed.Content(id: "0",
            image: UIImage(named: "fox.jpg")!,
            title: "tile",
            artistName: "MMMLLLKK")
        ]), isPlaying: .constant(false), playingTitle: .constant(""),
            onTapSkipButton: {},
            onTapPlayButton: {},
            onTapPauseButton: {}).previewDevice(PreviewDevice(rawValue: "iPhone XS"))
    }
}

