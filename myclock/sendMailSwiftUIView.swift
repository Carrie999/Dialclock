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
    @State var showEmailComposer = false

    var body: some View {
        HStack {
//            Image(systemName: "envelope.circle").imageScale(.large)
//           
//            Button("建议吐槽") {
//                        showEmailComposer = true
//                    }
//                    .sheet(isPresented: $showEmailComposer) {
//                        MailView(
//                            subject: "Email subject",
//                            message: "Message",
//                            attachment: nil,
//                            onResult: { _ in
//                                 // Handle the result if needed.
//                                 self.showEmailComposer = false
//                            }
//                        )
//                    }
            Button(action: {
                let mailto = "mailto:saintgirl@zohomail.cn?subject=dialClock&body= ".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                let mailTo = "mailto:nemecek@support.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let mailtoUrl = URL(string: mailto!)!
                if UIApplication.shared.canOpenURL(mailtoUrl) {
                        UIApplication.shared.open(mailtoUrl, options: [:])
                }
                
//                       self.isShowingMailView.toggle()
                   }) {
                       Text("建议吐槽")
                   }
//                   .disabled(!MFMailComposeViewController.canSendMail())
//                   .sheet(isPresented: $isShowingMailView) {
//                       MailView(result: self.$result)
//                   }
            
            
        }
        
//        .onTapGesture {
//            MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
//        }
//        //            .disabled(!MFMailComposeViewController.canSendMail())
//        .sheet(isPresented: $isShowingMailView) {
//            MailView(result: self.$result)
//        }
//        .alert(isPresented: self.$alertNoMail) {
//            Alert(title: Text("NO MAIL SETUP"))
//        }
    }
}




public struct MailView: UIViewControllerRepresentable {
    public struct Attachment {
        public let data: Data
        public let mimeType: String
        public let filename: String

        public init(data: Data, mimeType: String, filename: String) {
            self.data = data
            self.mimeType = mimeType
            self.filename = filename
        }
    }

    public let onResult: ((Result<MFMailComposeResult, Error>) -> Void)

    public let subject: String?
    public let message: String?
    public let attachment: Attachment?

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        public var onResult: ((Result<MFMailComposeResult, Error>) -> Void)

        init(onResult: @escaping ((Result<MFMailComposeResult, Error>) -> Void)) {
            self.onResult = onResult
        }

        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error = error {
                self.onResult(.failure(error))
            } else {
                self.onResult(.success(result))
            }
        }
    }

    public init(
        subject: String? = nil,
        message: String? = nil,
        attachment: MailView.Attachment? = nil,
        onResult: @escaping ((Result<MFMailComposeResult, Error>) -> Void)
    ) {
        self.subject = subject
        self.message = message
        self.attachment = attachment
        self.onResult = onResult
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onResult: onResult)
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        if let subject = subject {
            controller.setSubject(subject)
        }
        if let message = message {
            controller.setMessageBody(message, isHTML: false)
        }
        if let attachment = attachment {
            controller.addAttachmentData(
                attachment.data,
                mimeType: attachment.mimeType,
                fileName: attachment.filename
            )
        }
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) {
        // nothing to do here
    }
}

#Preview {
    sendMailSwiftUIView()
}
