//
//  TableViewCells.swift
//  T-Square
//
//  Created by Cal on 9/1/15.
//  Copyright © 2015 Georgia Tech. All rights reserved.
//

import Foundation
import UIKit

class ClassNameCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    func decorate(displayClass: Class) {
        nameLabel.text = displayClass.name
        subjectLabel.text = displayClass.subjectName ?? ""
    }
    
}

class AnnouncementCell : UITableViewCell {
    
    var announcement: Announcement!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    static var originalDescriptionText: NSAttributedString?
    
    func decorate(announcement: Announcement) {
        self.announcement = announcement
        
        if AnnouncementCell.originalDescriptionText == nil {
            AnnouncementCell.originalDescriptionText = descriptionLabel.attributedText
        }
        
        titleLabel.text = announcement.name
        
        if !announcement.hasBeenRead() {
            titleLabel.text = "⭐️ \(titleLabel.text!)"
        }
        
        //decorate label with time
        let timeAgo = announcement.date?.agoString() ?? announcement.rawDateString
        let className = announcement.owningClass.name
        let attributed = AnnouncementCell.originalDescriptionText?.mutableCopy() as? NSMutableAttributedString
            ?? descriptionLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        attributed.replaceCharactersInRange(NSMakeRange(18, 8), withString: className)
        attributed.replaceCharactersInRange(NSMakeRange(0, 14), withString: timeAgo)
        descriptionLabel.attributedText = attributed
    }
    
    static func presentAnnouncement(announcement: Announcement, inController controller: ClassesViewController) {
        let delegate = AnnouncementDelegate(announcement: announcement, controller: controller)
        controller.pushDelegate(delegate)
        controller.updateBottomView()
    }
    
}

class TitleCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func decorate(text: String) {
        titleLabel.text = text
    }
    
}

class AttachmentCell : TitleCell {
    
    var attachment: Attachment?
    @IBOutlet weak var background: UIView!
    
    override func decorate(text: String) {
        super.decorate(text)
        background.layer.cornerRadius = 5.0
        background.layer.masksToBounds = true
    }
    
    static func presentAttachment(attachment: Attachment, inController controller: ClassesViewController) {
        if let url = NSURL(string: attachment.link) {
            controller.presentDocumentFromURL(url)
        }
    }
    
}

class BackCell : UITableViewCell {
    
    @IBAction func backButtonPressed(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(TSBackNotification, object: nil)
    }
    
}
