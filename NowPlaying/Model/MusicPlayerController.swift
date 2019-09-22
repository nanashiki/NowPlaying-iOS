//
//  MusicPlayer.swift
//  NowPlaying
//
//  Created by beta on 2019/09/21.
//  Copyright © 2019 noppelab. All rights reserved.
//

import MediaPlayer

protocol MusicPlayerController {
    static var system: MusicPlayerController { get }
}

extension MPMusicPlayerController: MusicPlayerController {
    static var system: MusicPlayerController {
        return MPMusicPlayerController.systemMusicPlayer
    }
}

struct DummyMusicPlayerController: MusicPlayerController {
    static var system: MusicPlayerController {
        return DummyMusicPlayerController()
    }
}
