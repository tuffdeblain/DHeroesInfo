//
//  PlayerModel.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import Foundation


struct PlayerModel: Decodable {
    let soloCompetitiveRank: Int?
    let rankTier: Int?
    let leaderboardRank: Int?
    let competitiveRank: Int?
    let profile: Profile?
    let estimateMMR: MmrEstimate?
}

struct Profile: Decodable {
    let accountID: Int?
    let personaName: String?
    let name: String?
    let plus: Bool?
    let cheese: Int?
    let steamid: String?
    let avatarURL: String?
    let avatarMediumURL: String?
    let avatarFullURL: String?
    let profileURL: String?
    let lastLogin: String?
    let countryCode: String?
    let isContributor: Bool?
}

struct MmrEstimate: Decodable {
    let estimateMMR: Int?
}

struct WinRate: Decodable {
    let win: Int?
    let lose: Int?
}
