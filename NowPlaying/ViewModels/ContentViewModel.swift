//
//  ContentViewModel.swift
//  NowPlaying
//
//  Created by beta on 2019/09/22.
//  Copyright © 2019 noppelab. All rights reserved.
//

import Combine
import MediaPlayer

final class ContentViewModel: ObservableObject {
    var nowPlayingItem: MPMediaItem? = nil {
        didSet {
            if let item = nowPlayingItem {
                let content = Feed.Content(id: UUID().uuidString,
                                           image: item.artwork?.image(at: .init(width: 512, height: 512)) ?? UIImage(systemName: "music.note.list")!,
                                           title: item.title ?? "",
                                           artistName: item.artist ?? "")
                items.insert(content, at: 0)
            }
            playingItemTitle = nowPlayingItem?.title ?? ""
        }
    }
    private var cancellables: [AnyCancellable] = []
    @Published var authorizationStatus: MPMediaLibraryAuthorizationStatus = .notDetermined
    @Published var isPresentedPermissionRequestView: Bool = false
    @Published var items: [Feed.Content] = []
    @Published var isPlaying: Bool = false
    @Published var playingItemTitle: String = ""
    private var isReadyPlayerObserving: Bool = false
    
    private let player = MPMusicPlayerController.systemMusicPlayer
    
    init() {
        cancellables.append($authorizationStatus.sink(receiveValue: { (status) in
            switch status {
            case .authorized:
                self.didAuthorized()
            case .notDetermined:
                self.authorize()
            case .denied, .restricted:
                self.isPresentedPermissionRequestView = true
            @unknown default:
                preconditionFailure()
            }
        }))
        let content = Feed.Content(id: UUID().uuidString,
        image: UIImage(named: "iTunesArtwork")!,
        title: "Your Listening",
        artistName: "Siel")
        items.append(content)
    }
    
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
    
    func skip() {
        player.skipToNextItem()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func authorize() {
        MPMediaLibrary.requestAuthorization { (status) in
            self.updateAuthorizationStatus()
        }
    }
    
    lazy var onAppear: () -> Void = {
        self.updateAuthorizationStatus()
    }
    
    lazy var onPermissionViewDisappear: () -> Void = {
        self.updateAuthorizationStatus()
    }
    
    private func updateAuthorizationStatus() {
        DispatchQueue.main.async {
            self.authorizationStatus = MPMediaLibrary.authorizationStatus()
        }
    }
    
    private func didAuthorized() {
        DispatchQueue.main.async {
            self.internalDidAuthorized()
        }
    }
    
    private func internalDidAuthorized() {
        guard !isReadyPlayerObserving else { return }
        isReadyPlayerObserving = true
        
        self.nowPlayingItem = self.player.nowPlayingItem
        self.isPlaying = self.player.playbackState == .playing
        
        player.beginGeneratingPlaybackNotifications()
        let nc = NotificationCenter.default
        cancellables.append(nc.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
            .sink { (notification) in
                guard let player = notification.object as? MPMusicPlayerController else { return }
                self.nowPlayingItem = player.nowPlayingItem
        })
        cancellables.append(nc.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
            .sink { (notification) in
                guard let player = notification.object as? MPMusicPlayerController else { return }
                self.isPlaying = player.playbackState == .playing
        })
    }
}
