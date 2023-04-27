//
//  NetworkManager.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//



import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    static let shared = NetworkManager()
    
// MARK: Network Functions for HeroesVC
    func getDataForHeroes(_ completion: @escaping ([DotaHero]) -> Void) {
        var dotaHeroes: [DotaHero] = []
        AF.request(URLS.openDotaHeroURL.rawValue, method: .get)
            .validate()
        
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    for count in 1..<(json.count + 22) {
                        
                        let heroJSON = json["\(count)"]
                        
                        if (heroJSON["localized_name"].string != nil) {
                            let hero = DotaHero(id: heroJSON["id"].int,
                                                name: heroJSON["name"].string,
                                                localized_name: heroJSON["localized_name"].string,
                                                icon: heroJSON["icon"].string,
                                                primary_attr: heroJSON["primary_attr"].string,
                                                attack_type: heroJSON["attack_type"].string,
                                                img: heroJSON["img"].string,
                                                base_health: heroJSON["base_health"].int,
                                                base_health_regen: heroJSON["base_health_regen"].double,
                                                base_mana: heroJSON["base_mana"].int,
                                                base_mana_regen: heroJSON["base_mana_regen"].double,
                                                base_armor: heroJSON["base_armor"].int,
                                                base_attack_min: heroJSON["base_attack_min"].int,
                                                base_attack_max: heroJSON["base_attack_max"].int,
                                                base_str: heroJSON["base_str"].int,
                                                base_agi: heroJSON["base_agi"].int,
                                                base_int: heroJSON["base_int"].int,
                                                str_gain: heroJSON["str_gain"].double,
                                                agi_gain: heroJSON["agi_gain"].double,
                                                int_gain: heroJSON["int_gain"].double,
                                                move_speed: heroJSON["move_speed"].int)
                            dotaHeroes.append(hero)
                        }
                        
                    }
                    completion(dotaHeroes)
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    func getImageForHeroe(url: String, index: Int, completion: @escaping (Data) -> Void){
        AF.download(URLS.opedDotaURL.rawValue + url)
            .validate()
            .responseData { responseData in
                if let data = responseData.value {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                    
                }
            }
    }
    
    // MARK: Network functions for Player Profile
    
    func getPlayerInfo(url: String, completion: @escaping (PlayerModel) -> Void) {
       // var player: PlayerModel
        AF.request(url, method: .get)
            .validate()
        
            .responseJSON { player in
                switch player.result {
                case .success(let value):
                    let json = JSON(value)
                    let player = PlayerModel(soloCompetitiveRank: json["solo_competitive_rank"].int,
                                         rankTier: json["rank_tier"].int,
                                         leaderboardRank: json["leaderboard_rank"].int,
                                         competitiveRank: json["competitive_rank"].int,
                                         profile: Profile(accountID: json["profile"]["account_id"].int,
                                                          personaName: json["profile"]["personaname"].string,
                                                          name: json["profile"]["name"].string,
                                                          plus: json["profile"]["plus"].bool,
                                                          cheese: json["profile"]["cheese"].int,
                                                          steamid: json["profile"]["steamid"].string,
                                                          avatarURL: json["profile"]["avatar"].string,
                                                          avatarMediumURL: json["profile"]["avatarmedium"].string,
                                                          avatarFullURL: json["profile"]["avatarfull"].string,
                                                          profileURL: json["profile"]["profileurl"].string,
                                                          lastLogin: json["profile"]["last_login"].string,
                                                          countryCode: json["profile"]["loccountrycode"].string,
                                                          isContributor: json["profile"]["is_contributor"].bool),
                                         estimateMMR: MmrEstimate(estimateMMR: json["mmr_estimate"]["estimate"].int))
                    
                        
                    completion(player)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getPlayerAvatar(url: String, completion: @escaping (Data) -> Void){
        AF.download(url)
            .validate()
            .responseData { responseData in
                if let data = responseData.value {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }
    }
    
    func getWinRatePlayer(steamID: String, completion: @escaping (WinRate) -> Void) {
        AF.request(URLS.playerInfoURL.rawValue + steamID + "/wl")
            .validate()
            .responseJSON { dataWL in
                switch dataWL.result{
                    
                case .success(let value):
                    let json = JSON(value)
                    let winRate = WinRate(win: json["win"].int, lose: json["lose"].int)
                    
                    completion(winRate)
                case .failure(_):
                    print("error")
                }
            }
    }
    
    // MARK: Network Functions for Recent Matches
    
    func getPlayerRecentMatches(url: String, completion: @escaping ([RecentMatch]) -> Void) {
        var recentMatches: [RecentMatch] = []
        AF.request(url, method: .get)
            .validate()
        
            .responseJSON { recentMatch in
                switch recentMatch.result {
                case .success(let value):
                    let json = JSON(value)
                    for number in 0..<json.count {
                        recentMatches.append(RecentMatch(matchID: json[number]["match_id"].int,
                                                         playerSlot: json[number]["player_slot"].int,
                                                         radiantWin: json[number]["radiant_win"].bool,
                                                         duration: json[number]["duration"].int,
                                                         gameMode: json[number]["game_mode"].int,
                                                         lobbyType: json[number]["lobby_type"].int,
                                                         heroID: json[number]["hero_id"].int,
                                                         startTime: json[number]["start_time"].int,
                                                         kills: json[number]["kills"].int,
                                                         deaths: json[number]["deaths"].int,
                                                         assists: json[number]["assists"].int,
                                                         skill: json[number]["skill"].int,
                                                         xpPerMin: json[number]["xp_per_min"].int,
                                                         goldPerMin: json[number]["gold_per_min"].int,
                                                         heroDamage: json[number]["hero_damage"].int,
                                                         towerDamage: json[number]["tower_damage"].int,
                                                         heroHealing: json[number]["hero_healing"].int,
                                                         lastHits: json[number]["last_hits"].int,
                                                         lane: json[number]["lane"].int,
                                                         laneRole: json[number]["lane_role"].int,
                                                         roaming: json[number]["is_roaming"].bool,
                                                         partySize: json[number]["party_size"].int))
                    }
                        
                    completion(recentMatches)
                case .failure(let error):
                    print(error)
                }
            }
    }
    private init() {}
}

