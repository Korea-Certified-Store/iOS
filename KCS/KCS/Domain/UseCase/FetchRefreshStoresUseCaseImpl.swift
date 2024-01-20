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
        requestLocation: RequestLocation
    ) -> Observable<[Store]> {
        let newLocation = parallelTranslate(requestLocation: requestLocation)
        
        return repository.fetchRefreshStores(requestLocation: newLocation)
    }
    
    func parallelTranslate (requestLocation: RequestLocation) -> RequestLocation {
        let distance1 = sqrt(
            pow(requestLocation.northWest.longitude - requestLocation.southWest.longitude, 2)
            + pow(requestLocation.northWest.latitude - requestLocation.southWest.latitude, 2)
        )
        let distance2 = sqrt(
            pow(requestLocation.northWest.longitude - requestLocation.northEast.longitude, 2) +
            pow(requestLocation.northWest.latitude - requestLocation.northEast.latitude, 2)
        )
        
        let center = Location(
            longitude: (requestLocation.northWest.longitude + requestLocation.southEast.longitude) / 2.0,
            latitude: (requestLocation.northWest.latitude + requestLocation.southEast.latitude) / 2.0
        )
        
        var newLocation: RequestLocation
        if distance1 > 0.07 {
            newLocation = translateHeightLocations(
                loc1: requestLocation.northWest,
                loc2: requestLocation.northEast,
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
        
        return requestLocation
    }
    
    func translateHeightLocations(loc1: Location, loc2: Location, center: Location) -> RequestLocation {
        
        let slope = (loc2.latitude - loc1.latitude) / (loc2.longitude - loc1.longitude)
        
        let constant1 = 0.035 * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude
        
        let constant2 = (-0.035) * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude

        let newnorthWest = Location(
            longitude: (loc1.latitude + (loc1.longitude / slope) - constant1) / (slope + 1 / slope),
            latitude: (slope * loc1.latitude + loc1.longitude + constant1 / slope) / (slope + 1 / slope)
        )
        
        let newnorthEast = Location(
            longitude: (loc2.latitude + (loc2.longitude / slope) - constant1) / (slope + 1 / slope),
            latitude: (slope * loc2.latitude + loc2.longitude + constant1 / slope) / (slope + 1 / slope)
        )
        
        let newsouthEast = Location(
            longitude: (loc2.latitude + (loc2.longitude / slope) - constant2) / (slope + 1 / slope),
            latitude: (slope * loc2.latitude + loc2.longitude + constant2 / slope) / (slope + 1 / slope)
        )
        
        let newsouthWest = Location(
            longitude: (loc1.latitude + (loc1.longitude / slope) - constant2) / (slope + 1 / slope),
            latitude: (slope * loc1.latitude + loc1.longitude + constant2 / slope) / (slope + 1 / slope)
        )
        
        return RequestLocation(
            northWest: newnorthWest,
            southWest: newsouthWest,
            southEast: newsouthEast,
            northEast: newnorthEast
        )
    }
    
}
