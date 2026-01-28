//
//  AddressSearchWebView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import SwiftUI
import WebKit

struct AddressSearchWebView: UIViewRepresentable {

    // 주소 선택 완료 시 콜백
    let onSelect: (AddressSearchResult) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "callBackHandler")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white

        let url = URL(string: "https://e0ng.github.io/tamingo-address-search/")!
        webView.load(URLRequest(url: url))

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// Coordinator(js -> swift)
extension AddressSearchWebView {

    final class Coordinator: NSObject, WKScriptMessageHandler {

        let onSelect: (AddressSearchResult) -> Void

        init(onSelect: @escaping (AddressSearchResult) -> Void) {
            self.onSelect = onSelect
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard
                let body = message.body as? [String: Any],
                let roadAddress = body["roadAddress"] as? String,
                let jibunAddress = body["jibunAddress"] as? String,
                let zonecode = body["zonecode"] as? String
            else { return }

            let result = AddressSearchResult(
                roadAddress: roadAddress,
                jibunAddress: jibunAddress,
                zonecode: zonecode
            )

            DispatchQueue.main.async {
                self.onSelect(result)
            }
        }
    }
}

