//
//  PlayerControlView.swift
//  NowPlaying
//
//  Created by beta on 2019/09/22.
//  Copyright © 2019 noppelab. All rights reserved.
//

import SwiftUI

struct PlayerControlView: View {
    @Binding var isPlaying: Bool
    @Binding var title: String
    let onTapSkipButton: () -> Void
    let onTapPlayButton: () -> Void
    let onTapPauseButton: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Text(title).font(.body)
            Spacer()
            if isPlaying {
                Button(action: onTapPauseButton) {
                    Image(systemName: "pause.fill").frame(width: 36, height: 36, alignment: .center)
                }
            } else {
                Button(action: onTapPlayButton) {
                    Image(systemName: "play.fill").frame(width: 36, height: 36, alignment: .center)
                }
            }
            
            Button(action: onTapSkipButton) {
                Image(systemName: "forward.fill").frame(width: 36, height: 36, alignment: .center)
            }
        }.padding().frame(maxWidth: .infinity, alignment: .center)
         .background(BlurView(style: .systemThinMaterial))
         .foregroundColor(Color.primary)
         .cornerRadius(16)
         .padding()
    }
}

struct PlayerControlView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlView(isPlaying: .constant(false), title: .constant("title"), onTapSkipButton: {}, onTapPlayButton: {}, onTapPauseButton: {}).previewLayout(.sizeThatFits)
    }
}
