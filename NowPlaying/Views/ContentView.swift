//
//  ContentView.swift
//  NowPlaying
//
//  Created by beta on 2019/09/21.
//  Copyright © 2019 noppelab. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject(initialValue: .init()) var viewModel: ContentViewModel
    
    var body: some View {
        Group {
            Feed.ContentView(contents: $viewModel.items,
                             isPlaying: $viewModel.isPlaying,
                             playingTitle: $viewModel.playingItemTitle,
                             onTapSkipButton: { self.viewModel.skip() },
                             onTapPlayButton: { self.viewModel.play() },
                             onTapPauseButton: { self.viewModel.pause() }
            )
        }.sheet(isPresented: $viewModel.isPresentedPermissionRequestView,
                onDismiss: viewModel.onPermissionViewDisappear, content: {
            PermissionView()
        }).onAppear(perform: viewModel.onAppear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
