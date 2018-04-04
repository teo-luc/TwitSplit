//
//  ViewController.swift
//  TwitSplit
//
//  Created by Tèo Lực on 4/4/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messTextView: UITextView!
    @IBOutlet weak var messTextView_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messGroupView_paddingBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    // In this case, I think that the good idea is create a custom object and store it to database
    private var sections = [[String]?]()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardStateNotifications()
        self.addSingleTabGesture()
        messTextView.delegate = self
    }
    
    deinit {
        removeKeyboardStateNotifications()
    }
    
    // MARK: Actions
    
    @IBAction private func sendMessageAction(_ sender: Any) {
        if let message = messTextView.text {
            if message.count != 0 {
                // Split the messge with DefaultMessageChunkSize = 50
                if let splitText = message.splitText(DefaultMessageChunkSize) {
                    self.sections.append(splitText)
                } else {
                    // Handle error case
                    // How to check error?
                    // Answer:  When the lenght of the message is lager DefaultMessageChunkSize, it will appear error UI
                    //          on tableView
                    self.sections.append([message])
                }
                // Insert section
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.scrollToTheLastSection()
                }
                tableView.beginUpdates()
                tableView.insertSections(NSIndexSet.init(index: self.sections.count - 1) as IndexSet, with: .top)
                tableView.endUpdates()
                CATransaction.commit()
            }
        }
        // Clear the message and hide keyboard ASAP
        messTextView.text = ""
        messTextView.resignFirstResponder()
        textViewDidChange(messTextView)
    }
}

// MARK: ViewController+UITextViewDelegate extension

extension ViewController {
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the content size of the TextView
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        // Set height of the textView
        messTextView_heightConstraint.constant = min(newSize.height, (UIScreen.main.bounds.height / 4))
        // Create animation when changed the constraint
        self.view.layoutIfNeeded(animation: DefaultAnimationDuration)
    }
}

// MARK: ViewController+KeyboardStateNotifications extension

extension ViewController {
    // Setup keyboard notifications
    private func addKeyboardStateNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    // Remove notification when the UIViewController is dead
    private func removeKeyboardStateNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            self.messGroupView_paddingBottomConstraint.constant = -keyboardHeight
            self.view.layoutIfNeeded(animation: DefaultAnimationDuration)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.messGroupView_paddingBottomConstraint.constant = 0
        self.view.layoutIfNeeded(animation: DefaultAnimationDuration)
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        self.scrollToTheLastSection()
    }
}

// MARK: ViewController+UITableView extension

extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        let section = sections.count
        return section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return (sections[section]?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BubbleViewCell = tableView.dequeueReusableCell(withIdentifier: "BubbleViewCell", for: indexPath) as! BubbleViewCell;
        // Get the messages from section
        let messagesInSection = sections[indexPath.section]
        // Get total messages and message
        let totalMessages:Int = (messagesInSection?.count)!
        let mess:String = (messagesInSection![indexPath.row]);
        // Find kind of error message if need
        if mess.count > DefaultMessageChunkSize {
            cell.hasError = true
            cell.isLastCell = false
            cell.messLabel?.text = "Error! Message content is too large."
        } else {
            cell.hasError = false
            cell.isLastCell = (indexPath.row == (totalMessages - 1))
            cell.messLabel?.text = "\(indexPath.row + 1)/\(totalMessages) \(mess)"
        }
        return cell
    }
    
    private func scrollToTheLastSection() {
        if sections.count != 0 {
            let lastSection = sections.count - 1
            let lastRow = (sections[lastSection]?.count)! - 1
            self.tableView.scrollToRow(at: NSIndexPath.init(row: lastRow, section: lastSection) as IndexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: ViewController+Gesture extension

extension ViewController {
    private func addSingleTabGesture() {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(singleTab))
        self.tableView.addGestureRecognizer(gesture)
    }
    
    @objc private func singleTab() {
        self.messTextView.resignFirstResponder()
    }
}
