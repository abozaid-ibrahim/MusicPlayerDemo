//
//  FeedJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

import Foundation

// MARK: - SongsListElement

 typealias SongsList = [SongEntity]
 struct SongEntity: Codable {
     let id: String?
     let createdAt: String?
     let userId: String?
     let duration: String?
     let permalink: String?
     let SongsListDescription: String?
     let genre: String?
     let genreSlush: String?
     let title: String?
     let uri: String?
     let permalinkUrl: String?
     let artworkUrl: String?
     let backgroundUrl: String?
     let waveformData: String?
     let waveformUrl: String?
     let user: Artist?
     let streamUrl: String?
     let downloadUrl: String?
     let favorited: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case userId = "user_id"
        case duration
        case permalink
        case SongsListDescription = "description"
        case genre
        case genreSlush = "genre_slush"
        case title
        case uri
        case permalinkUrl = "permalink_url"
        case artworkUrl = "artwork_url"
        case backgroundUrl = "background_url"
        case waveformData = "waveform_data"
        case waveformUrl = "waveform_url"
        case user
        case streamUrl = "stream_url"
        case downloadUrl = "download_url"
        case favorited
    }

     init(id: String?, createdAt: String?, userId: String?, duration: String?, permalink: String?, SongsListDescription: String?, genre: String?, genreSlush: String?, title: String?, uri: String?, permalinkUrl: String?, artworkUrl: String?, backgroundUrl: String?, waveformData: String?, waveformUrl: String?, user: Artist?, streamUrl: String?, downloadUrl: String?, favorited: Bool?) {
        self.id = id
        self.createdAt = createdAt
        self.userId = userId
        self.duration = duration
        self.permalink = permalink
        self.SongsListDescription = SongsListDescription
        self.genre = genre
        self.genreSlush = genreSlush
        self.title = title
        self.uri = uri
        self.permalinkUrl = permalinkUrl
        self.artworkUrl = artworkUrl
        self.backgroundUrl = backgroundUrl
        self.waveformData = waveformData
        self.waveformUrl = waveformUrl
        self.user = user
        self.streamUrl = streamUrl
        self.downloadUrl = downloadUrl

        self.favorited = favorited
    }

     init(id: String?, userId: String?, user: Artist?, streamUrl: String?) {
        self.id = id
        createdAt = .none
        self.userId = userId
        duration = .none
        permalink = .none
        SongsListDescription = .none
        genre = .none
        genreSlush = .none
        title = .none
        uri = .none
        permalinkUrl = .none
        artworkUrl = .none
        backgroundUrl = .none
        waveformData = .none
        waveformUrl = .none
        self.user = user
        self.streamUrl = streamUrl
        downloadUrl = .none
        favorited = .none
    }
}

// MARK: - User

 struct Artist: Codable {
     let id: String?
     let permalink: String?
     let username: String?
     let uri: String?
     let permalinkUrl: String?
     let avatarUrl: String?

    var songsCount: Int = 0
    enum CodingKeys: String, CodingKey {
        case id
        case permalink
        case username
        case uri
        case permalinkUrl = "permalink_url"
        case avatarUrl = "avatar_url"
    }

     init(id: String?, permalink: String?, username: String?, uri: String?, permalinkUrl: String?, avatarUrl: String?) {
        self.id = id
        self.permalink = permalink
        self.username = username
        self.uri = uri
        self.permalinkUrl = permalinkUrl
        self.avatarUrl = avatarUrl
    }
}
