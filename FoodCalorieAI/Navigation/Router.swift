//
//  Router.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import Foundation
import Combine

enum AppRoute: Hashable {
    case camera
    case scanResultView
    case recommendationView
    case responseLanguageView
}


final class Router: ObservableObject {
    @Published var path: [AppRoute] = []
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
}

