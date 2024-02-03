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
    
}

private extension FetchRefreshStoresUseCaseImpl {
    
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
                newLocation = translateHeightLocations(
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
        if loc1.latitude == loc2.latitude {
            return RequestLocation(
                northWest: Location(longitude: loc1.longitude, latitude: center.latitude + 0.035),
                southWest: Location(longitude: loc1.longitude, latitude: center.latitude - 0.035),
                southEast: Location(longitude: loc2.longitude, latitude: center.latitude - 0.035),
                northEast: Location(longitude: loc2.longitude, latitude: center.latitude + 0.035)
            )
        } else if loc1.longitude == loc2.longitude {
            return RequestLocation(
                northWest: Location(longitude: center.longitude + 0.035, latitude: loc1.latitude),
                southWest: Location(longitude: center.longitude - 0.035, latitude: loc1.latitude),
                southEast: Location(longitude: center.longitude - 0.035, latitude: loc2.latitude),
                northEast: Location(longitude: center.longitude + 0.035, latitude: loc2.latitude)
            )
        }
        
        let slope = (loc2.latitude - loc1.latitude) / (loc2.longitude - loc1.longitude)
        let constant1 = 0.035 * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude
        let constant2 = (-0.035) * sqrt(pow(slope, 2) + 1) - slope * center.longitude + center.latitude
        
        return RequestLocation(
            northWest: getNewLocation(location: loc1, slope: slope, constant: constant1),
            southWest: getNewLocation(location: loc1, slope: slope, constant: constant2),
            southEast: getNewLocation(location: loc2, slope: slope, constant: constant2),
            northEast: getNewLocation(location: loc2, slope: slope, constant: constant1)
        )
    }
    
    func getNewLocation(location: Location, slope: Double, constant: Double) -> Location {
        return Location(
            longitude: (location.latitude + (location.longitude / slope) - constant) / (slope + 1 / slope),
            latitude: (slope * location.latitude + location.longitude + constant / slope) / (slope + 1 / slope)
        )
    }
    
}
