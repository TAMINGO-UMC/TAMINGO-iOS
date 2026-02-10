//
//  RouteFindViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

@Observable
final class RouteFindViewModel {

    private let route: RouteResultModel

    init(route: RouteResultModel) {
        self.route = route
    }
}
