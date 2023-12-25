//
//  ViewController.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import NMapsMap

final class HomeViewController: UIViewController {

    private let mapView: NMFMapView = {
        let map = NMFMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
    }

}

private extension HomeViewController {
    
    func addUIComponents() {
        view.addSubview(mapView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}
