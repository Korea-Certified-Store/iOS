//
//  StoreDTO.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

// MARK: - StoreDTO
struct StoreDTO: Codable {
    
    let id: Int
    let googlePlaceID: String
    let displayName: String
    let primaryTypeDisplayName: String
    let formattedAddress: String
    let phoneNumber: String
    let location: Location
    let regularOpeningHours: [RegularOpeningHour]
    let localPhotos: [String]
    let certificationName: [String]

    enum CodingKeys: String, CodingKey {
        
        case id
        case googlePlaceID = "googlePlaceId"
        case displayName
        case primaryTypeDisplayName
        case formattedAddress
        case phoneNumber
        case location
        case regularOpeningHours
        case localPhotos
        case certificationName
        
    }
    
}

struct Location: Codable {
    
    let longitude: Double
    let latitude: Double
    
}

struct RegularOpeningHour: Codable {
    
    let open: BusinessHour
    let close: BusinessHour

    enum CodingKeys: String, CodingKey {
        case open
        case close
    }
    
}

struct BusinessHour: Codable {
    
    let day: String
    let hour: Int
    let minute: Int
    
}

//enum Day: String, Codable {
//    
//    case monday = "MON"
//    case tuesday = "TUE"
//    case wednesday = "WED"
//    case thursday = "THU"
//    case friday = "FRI"
//    case saturday = "SAT"
//    case sunday = "SUN"
//    
//}
