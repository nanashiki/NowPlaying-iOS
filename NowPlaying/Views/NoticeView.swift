//
//  NoticeView.swift
//  NowPlaying
//
//  Created by beta on 2019/09/22.
//  Copyright © 2019 noppelab. All rights reserved.
//

import SwiftUI

struct NoticeView: View {
    var body: some View {
        Text("You are not playing a music.")
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(16)
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView().previewLayout(.sizeThatFits).environment(\.colorScheme, .dark)
//        NoticeView().previewLayout(.sizeThatFits).environment(\.colorScheme, .light)
    }
}

