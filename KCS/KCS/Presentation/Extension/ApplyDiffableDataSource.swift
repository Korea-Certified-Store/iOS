//
//  ApplyDiffableDataSource.swift
//  KCS
//
//  Created by 김영현 on 2/23/24.
//

import UIKit

struct ApplyDiffableDataSource<SectionType: Hashable, IdentifierType: Hashable> {
    
    func applyDiffableDataSource(
        dataSource: UITableViewDiffableDataSource<SectionType, IdentifierType>,
        section: [SectionType],
        data: [IdentifierType]
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, IdentifierType>()
        snapshot.appendSections(section)
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
