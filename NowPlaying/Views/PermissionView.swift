//
//  PermissionView.swift
//  NowPlaying
//
//  Created by beta on 2019/09/21.
//  Copyright © 2019 noppelab. All rights reserved.
//

import SwiftUI

struct PermissionView: View {
    @ObservedObject(initialValue: .init()) var viewModel: PermissionViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("再生情報へのアクセスに失敗しました。").font(.largeTitle).lineLimit(2)
            Text("設定アプリを開いて、「メディアとApple Music」へのアクセスを許可してください。").font(.subheadline).lineLimit(2)
            Button(action: {
                self.viewModel.openSettings()
            }) {
                Text("設定アプリを開く")
            }
        }.padding()
    }
}

import MediaPlayer

final class PermissionViewModel: ObservableObject {
    func openSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
