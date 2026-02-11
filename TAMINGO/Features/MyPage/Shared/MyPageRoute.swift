//
//  MyPageRout.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import SwiftUI

enum MyPageRoute : Hashable {
    case weeklyReport
    case scheduleCategory
    case todoCategory
    case calendarSetting
    case favoritePlace
    case activityTime
    case transport
    case notification
    case personalization
    case setting
}

struct MyPageRootView: View {
    @State private var path: [MyPageRoute] = []
    @State private var myPageViewModel = MyPageViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            MyPageView(onSelect: { route in
                path.append(route)
            }, vm: myPageViewModel)
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .weeklyReport:
                    WeeklyReportView(
                        weeklyMetrics: weeklyMetricMocks, comparisonMetrics: weeklyComparisonMocks,
                        onBack: {path.removeLast()}
                    )
                case .scheduleCategory:
                    CategoryView(type: .schedule, vm: ScheduleCategoryViewModel(), onBack: {
                        path.removeLast()
                    } )
                case .todoCategory:
                    CategoryView(
                        type: .todo,
                        vm: TodoCategoryViewModel(),
                        onBack: {
                            path.removeLast()
                        }
                    )
                case .calendarSetting:
                    CalendarSyncView(onBack: {
                        path.removeLast()
                    })
                case .favoritePlace:
                    FavoritPlacesView(onBack: {
                        path.removeLast()
                    })
                case .activityTime:
                    ActivityTimeSettingView(
                        onSave: { activityTime in
                            myPageViewModel.updateActivityTime(activityTime)
                        }, onBack: {
                            path.removeLast()
                        }
                    )

                case .transport:
                    TransportRankSettingView(onBack: {
                        path.removeLast()
                    })
                case .notification:
                    NotificationView()
                case .personalization:
                        PersonalizationView()
                case .setting:
                    SettingsView()
                }
            }
        }
    }
}
