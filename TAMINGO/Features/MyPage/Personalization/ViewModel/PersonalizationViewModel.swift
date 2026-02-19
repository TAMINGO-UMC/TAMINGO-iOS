//
//  PersonalizationViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import SwiftUI
import Moya
import Alamofire

@Observable
@MainActor
class PersonalizationViewModel {
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    private let provider: MoyaProvider<PersonalizationTarget>
    
    private var isFetching: Bool = false
    
    var personalizationSetting: Bool = true
    
    var patternCount: Int = 0
    var avgAccuracy: Int = 0
    var fvpCount: Int = 0
    
    var recentPersonalized : [PersonalizationDTO] = []

    init() {
        self.provider = MoyaProvider<PersonalizationTarget>(
            session: session,
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))]
        )
    }
    
    func loadSetting() async {
        isFetching = true
        defer {
            _Concurrency.Task {
                try? await _Concurrency.Task.sleep(nanoseconds: 500_000_000)
                self.isFetching = false
            }
        }
        
        do {
            let response: BaseResponse<PersonalizationSettings> = try await provider.request(.getSettings)
            
            if let settings = response.result?.isErrorLogEnabled {
                self.personalizationSetting = settings
            }
        } catch {
            print("로드 실패: \(error)")
        }
    }

    func loadStatistics() async {
        do {
            let response: BaseResponse<PersonalizationSummaryDTO> = try await provider.request(.getSummary)
            self.patternCount = response.result?.patternCount ?? 0
            self.avgAccuracy = response.result?.avgAccuracy ?? 0
            self.fvpCount = response.result?.fvpCount ?? 0
        } catch {
            print("\(error)")
        }
    }

    func loadRecent() async {
        do {
            let response: BaseResponse<[PersonalizationDTO]> = try await provider.request(.getRecent)
            if let result = response.result {
                self.recentPersonalized = result
            }
        } catch {
            print("\(error)")
        }
    }
    
    func updateSetting() async {
        guard !isFetching else { return }
        
        let dto = PersonalizationSettings(isErrorLogEnabled: self.personalizationSetting)
        
        do {
            let _: BaseResponse<PersonalizationSettings> = try await provider.request(.putSettings(body: dto))
        } catch {
            print("업데이트 실패: \(error)")
        }
    }
    
    func resetData() async {
        do {
            let _: BaseResponse<PersonalizationSettings> = try await provider.request(.resetSummary)
            await loadRecent()
            await loadSetting()
            await loadStatistics()
        } catch {
            print("\(error)")
        }
    }
}
