//
//  AppToastView.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/4/27.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
fileprivate class AppToastViewModel: ObservableObject {
    @Published var message = "Message"
}

@available(iOS 13.0, *)
fileprivate struct AppToastView: View {
    @ObservedObject var viewModel: AppToastViewModel
    var body: some View {
        ZStack {
            Text(viewModel.message)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .lineSpacing(8)
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
        }
        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.7))
        .cornerRadius(16)
        .padding(EdgeInsets(top: 16, leading: 44, bottom: 16, trailing: 44))
    }
}

@available(iOS 13.0, *)
@objcMembers public class AppToast: NSObject {
    
    private override init() {}
    private var viewModel: AppToastViewModel?
    private var hostVC: UIHostingController<AppToastView>?
    private var timerCancellable: AnyCancellable?
    private static let instance = AppToast()
    
    func show(_ message: String, hideAfter: TimeInterval = 1) {
        if viewModel == nil  {
            if let keyWin = UIApplication.shared.keyWindow {
                
                let viewModel = AppToastViewModel()
                let toastView = AppToastView(viewModel: viewModel)
                let hostVC = UIHostingController(rootView: toastView)
                hostVC.view.isUserInteractionEnabled = false
                hostVC.view.backgroundColor = .clear
                
                hostVC.view.frame = keyWin.bounds
                keyWin.addSubview(hostVC.view)
                
                self.viewModel = viewModel
                self.hostVC = hostVC
            }
        }
        
        guard let viewModel else {
            return
        }
        
        // 更新文案
        viewModel.message = message
        
        // 及时后移除
        if let timerCancellable {
            timerCancellable.cancel()
        }
        timerCancellable = Timer.publish(every: hideAfter, on: .main, in: .common).autoconnect().sink(receiveValue: { [weak self] _ in
            self?.hostVC?.view.removeFromSuperview()
            self?.hostVC = nil
            self?.viewModel = nil
            self?.timerCancellable?.cancel()
            self?.timerCancellable = nil
        })
    }
    
    public class func show(_ message: String, hideAfter: TimeInterval = 1) {
        instance.show(message, hideAfter: hideAfter)
    }
}
