//
//  AttachmentTableViewController.swift
//  SMSDemo
//
//  Created by Simon Ng on 6/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import MessageUI


class AttachmentTableViewController: UITableViewController {

    let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return filenames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        sendSMS(attachment: selectedFile)
    }
    
    func sendSMS(attachment: String) {
        
        // 檢查裝置是否能傳送文字訊息
        guard MFMessageComposeViewController.canSendText() else {
            let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Your device is not capable of sending SMS.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        
        // SMS預填
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = ["12345678", "72345524"]
        messageController.body = "Just sent the \(attachment) to your email. Please check!"
        
        // 加上附件
        let fileparts = attachment.components(separatedBy: ".")
        let filename = fileparts[0]
        let fileExtension = fileparts[1]
        let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension)
        let fileUrl = NSURL.fileURL(withPath: filePath!)
        messageController.addAttachmentURL(fileUrl, withAlternateFilename: nil)
   
        // 在畫面上呈現訊息視圖控制器
        present(messageController, animated: true, completion: nil)
        
        
    }
}

extension AttachmentTableViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch(result) {
        case MessageComposeResult.cancelled:
            print("SMS cancelled")
            
        case MessageComposeResult.failed:
            let alertMessage = UIAlertController(title: "Failure", message: "Failed to send the message", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            
        case MessageComposeResult.sent:
            print("SMS sent")
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
