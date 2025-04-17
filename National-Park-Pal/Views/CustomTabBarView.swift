//
//  CustomTabBarView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/13/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel

    var body: some View {
        HStack {
            Spacer()
            
            NavigationLink(destination: UserParksView(userModel: userModel).environmentObject(tabModel)) {
                Image(systemName: tabModel.selectedTab == 0 ? "bookmark.fill" : "bookmark")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .simultaneousGesture(TapGesture().onEnded {
                tabModel.selectedTab = 0
            })

            Spacer()

            NavigationLink(destination: MapView().environmentObject(tabModel)) {
                Image(systemName: tabModel.selectedTab == 1 ? "map.fill" : "map")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .simultaneousGesture(TapGesture().onEnded {
                tabModel.selectedTab = 1
            })

            Spacer()

            NavigationLink(destination: HomePageView(userModel: userModel).environmentObject(tabModel)) {
                Image(systemName: tabModel.selectedTab == 2 ? "house.fill" : "house")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .simultaneousGesture(TapGesture().onEnded {
                tabModel.selectedTab = 2
            })
            .disabled(tabModel.selectedTab == 2)

            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(Color.white.ignoresSafeArea(edges: .bottom).shadow(radius: 5))
    }
}

#Preview {
    CustomTabBarView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}

