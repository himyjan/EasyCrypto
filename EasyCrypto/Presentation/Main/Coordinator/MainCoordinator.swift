//
//  MainCoordinator.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import SwiftUI

struct MainCoordinator: Coordinator, DependencyAssemblerInjector {
    
    @State var activeRoute: Destination? = Destination(route: .first(item: MarketsPrice()))
    @State var transition: Transition?
    
    var body: some View {
        mainView
            .route(to: $activeRoute)
            .navigation()
            .onAppear {
                self.mainView.viewModel.navigate = navigate(to:)
            }
    }
    
    var mainView: MainView {
        return self.dependencyAssembler.makeMainView(coordinator: self)
    }
    
    func navigate(to route: MainView.Routes) {
        activeRoute = Destination(route: route)
    }
}

extension MainCoordinator {
    struct Destination: RouteDestination, DependencyAssemblerInjector {
        
        var route: MainView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .first(let data):
                DetailView(item: data)
            case .second(let data):
                CoinDetailView(id: data, viewModel: self.dependencyAssembler.makeCoinDetailViewModel())
            }
        }
        
        var transition: Transition {
            switch route {
            case .first: return .push
            case .second: return .push
            }
        }
    }
}


