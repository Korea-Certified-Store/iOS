//
//  StoreDTO.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct StoreDTO: Codable {
    
    let id: Int
    let displayName: String
    let primaryTypeDisplayName: String?
    let formattedAddress: String
    let phoneNumber: String?
    let location: LocationDTO
    let regularOpeningHours: [RegularOpeningHourDTO]
    let localPhotos: [String]
    let certificationName: [String]

    enum CodingKeys: String, CodingKey {
        
        case id
        case displayName
        case primaryTypeDisplayName
        case formattedAddress
        case phoneNumber
        case location
        case regularOpeningHours
        case localPhotos
        case certificationName
        
    }
    
    func toEntity() -> Store {
        
        var certificationTypes: [CertificationType] = []
        var storeCategory: StoreCategory?
        var openingHours: [RegularOpeningHours] = []
        
        do {
            for name in certificationName {
                guard let type = CertificationType(rawValue: name) else {
                    throw JSONContentsError.wrongCertificationType
                }
                certificationTypes.append(type)
            }
            
            if let typeName = primaryTypeDisplayName {
                guard let category = StoreCategory(rawValue: typeName) else {
                    throw JSONContentsError.wrongCategory
                }
                storeCategory = category
            }
            
            for hour in regularOpeningHours {
                openingHours.append(try hour.toEntity())
            }
        } catch let error {
            dump(error.localizedDescription)
        }
        
        return Store(
            title: displayName,
            certificationTypes: certificationTypes,
            category: storeCategory,
            address: formattedAddress,
            phoneNumber: phoneNumber,
            location: location.toEntity(),
            openingHour: openingHours
        )
    }
    
}

struct LocationDTO: Codable {
    
    let longitude: Double
    let latitude: Double
    
    func toEntity() -> Location {
        return Location(
            longitude: longitude,
            latitude: latitude
        )
    }
    
}

struct RegularOpeningHourDTO: Codable {
    
    let open: BusinessHourDTO
    let close: BusinessHourDTO

    enum CodingKeys: String, CodingKey {
        case open
        case close
    }
    
    func toEntity() throws -> RegularOpeningHours {
        return RegularOpeningHours(
            open: try open.toEntity(),
            close: try close.toEntity()
        )
    }
    
}

struct BusinessHourDTO: Codable {
    
    let day: String
    let hour: Int
    let minute: Int
    
    func toEntity() throws -> BusinessHour {
        guard let entityDay = Day(rawValue: day) else {
            throw JSONContentsError.wrongDay
        }
        
        return BusinessHour(
            day: entityDay,
            hour: hour,
            minute: minute
        )
    }
    
}
