//
//  DotaHero.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import Foundation


struct DotaHero: Decodable {
    var id: Int?
    var name: String?
    var localized_name: String?
    var icon: String?
    var iconData: Data?
    var primary_attr: String?
    var attack_type: String?
    var img: String?
    var base_health: Int?
    var base_health_regen: Double?
    var base_mana: Int?
    var base_mana_regen: Double?
    var base_armor: Int?
    var base_attack_min: Int?
    var base_attack_max: Int?
    var base_str: Int?
    var base_agi: Int?
    var base_int: Int?
    var str_gain: Double?
    var agi_gain: Double?
    var int_gain: Double?
    var attack_range: Int?
    var attack_rate: Double?
    var move_speed: Int?
}
