//
//  sendMailSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/27.
//

import SwiftUI
import MessageUI
import AppIntents
import AVFoundation
import Foundation
import UIKit



struct sendMailSwiftUIView: View {
    @State var isShowingMailView = false
    @State var alertNoMail = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    var body: some View {
        HStack {
//            Image(systemName: "envelope.circle").imageScale(.large)
            Text("建议吐槽")
        }.onTapGesture {
            MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
        }
        //            .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result)
        }
        .alert(isPresented: self.$alertNoMail) {
            Alert(title: Text("NO MAIL SETUP"))
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    var recipients = [String]()
    var messageBody = ""
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>)
        {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?)
        {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
            
            if result == .sent {
                AudioServicesPlayAlertSound(SystemSoundID(1001))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(recipients)
        vc.setMessageBody(messageBody, isHTML: true)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_: MFMailComposeViewController,
                                context _: UIViewControllerRepresentableContext<MailView>) {}
}


#Preview {
    sendMailSwiftUIView()
}
