//
//  FetchRefreshStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

struct FetchRefreshStoresUseCaseImpl: FetchRefreshStoresUseCase {
    
    let repository: StoreRepository
    
    func execute(
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> Observable<[Store]> {
        let newLocation = parallelTranslate(
            northWestLocation: northWestLocation,
            southWestLocation: southWestLocation,
            southEastLocation: southEastLocation,
            northEastLocation: northEastLocation
        )
        
        return repository.fetchRefreshStores(
            northWestLocation: newLocation.northWest,
            southWestLocation: newLocation.southWest,
            southEastLocation: newLocation.southEast,
            northEastLocation: newLocation.northEast
        )
    }
    
    func parallelTranslate (
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> RequestLocation {
        let distance1 = sqrt(
            pow(northWestLocation.longitude - southWestLocation.longitude, 2)
            + pow(northWestLocation.latitude - southWestLocation.latitude, 2)
        )
        let distance2 = sqrt(
            pow(northWestLocation.longitude - northEastLocation.longitude, 2) +
            pow(northWestLocation.latitude - northEastLocation.latitude, 2)
        )
        
        let center = Location(
            longitude: (northWestLocation.longitude + southEastLocation.longitude) / 2.0,
            latitude: (northWestLocation.latitude + southEastLocation.latitude) / 2.0
        )
        
        var newLocation: RequestLocation
        if distance1 > 0.07 {
            newLocation = translateHeightLocations(
                loc1: northWestLocation,
                loc2: northEastLocation,
                center: center
            )
            if distance2 > 0.07 {
                return translateHeightLocations(
                    loc1: newLocation.northEast,
                    loc2: newLocation.southEast,
                    center: center
                )
            }
            return newLocation
        }
        
        return RequestLocation(
            northWest: northWestLocation,
            southWest: southWestLocation,
            southEast: southEastLocation,
            northEast: northEastLocation
        )
    }
    
    func translateHeightLocations(loc1: Location, loc2: Location, center: Location) -> RequestLocation {
        
        let slope = (loc2.latitude - loc1.latitude) / (loc2.longitude - loc1.longitude)
        
        let constant1 = 0.035 * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude
        
        let constant2 = (-0.035) * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude

        let newNorthWestLocation = Location(
            longitude: (loc1.latitude + (loc1.longitude / slope) - constant1) / (slope + 1 / slope),
            latitude: (slope * loc1.latitude + loc1.longitude + constant1 / slope) / (slope + 1 / slope)
        )
        
        let newNorthEastLocation = Location(
            longitude: (loc2.latitude + (loc2.longitude / slope) - constant1) / (slope + 1 / slope),
            latitude: (slope * loc2.latitude + loc2.longitude + constant1 / slope) / (slope + 1 / slope)
        )
        
        let newSouthEastLocation = Location(
            longitude: (loc2.latitude + (loc2.longitude / slope) - constant2) / (slope + 1 / slope),
            latitude: (slope * loc2.latitude + loc2.longitude + constant2 / slope) / (slope + 1 / slope)
        )
        
        let newSouthWestLocation = Location(
            longitude: (loc1.latitude + (loc1.longitude / slope) - constant2) / (slope + 1 / slope),
            latitude: (slope * loc1.latitude + loc1.longitude + constant2 / slope) / (slope + 1 / slope)
        )
        
        return RequestLocation(
            northWest: newNorthWestLocation,
            southWest: newSouthWestLocation,
            southEast: newSouthEastLocation,
            northEast: newNorthEastLocation
        )
    }
    
}
