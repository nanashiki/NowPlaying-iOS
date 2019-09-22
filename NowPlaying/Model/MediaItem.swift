//
//  MediaItem.swift
//  NowPlaying
//
//  Created by beta on 2019/09/21.
//  Copyright © 2019 noppelab. All rights reserved.
//

import MediaPlayer

protocol MediaItem {
    var title: String? { get }
}

extension MPMediaItem: MediaItem {}

struct DummyMediaItem: MediaItem {
    let title: String? = "dummy title"
}
