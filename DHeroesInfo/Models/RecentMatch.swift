//
//  RecentMatch.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import Foundation

struct RecentMatch: Decodable {
    var matchID: Int?
    var playerSlot: Int?
    var radiantWin: Bool?
    var duration: Int?
    var gameMode: Int?
    var lobbyType: Int?
    var heroID: Int?
    var startTime: Int?
    var kills: Int?
    var deaths: Int?
    var assists: Int?
    var skill: Int?
    var xpPerMin: Int?
    var goldPerMin: Int?
    var heroDamage: Int?
    var towerDamage: Int?
    var heroHealing: Int?
    var lastHits: Int?
    var lane: Int?
    var laneRole: Int?
    var roaming: Bool?
    var partySize: Int?
}
