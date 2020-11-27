//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

/// FileLogger with Debug-OnScreen-Output
///
/// Shake the device to show the debug tool
public class OnScreenFileLogger: FileLogger {
    
    // MARK: - Const
    
    private enum Strings {
        static let close = "Close"
        static let share = "Share"
        static let currentLog = "Show Current Log"
        static let prevLog = "Show Prev Log"
        static let touch = "Touch"
        static let cancel = "Cancel"
        static let ok = "OK"
        static let touchEnabled = "Touch enabled"
        static let touchMessage = "You can use the app now.\nShake again to show buttons."
    }
    
    
    // MARK: - Properties
	
    private var loggerWindow: UIWindow?
    private var visibleLogFile: LogFile?
    private var shakeEnabled = false
    
    private var containerView: UIView?
    private var contentStackView: UIStackView?
    private var textView: UITextView?
    private var buttonStackView: UIStackView?
    
    // MARK: - Init
    
    public override init(outputQueue: DispatchQueue = .defaultLoggingQueue()) {
        super.init(outputQueue: outputQueue)
    }
    
    /// Initialize logger
    ///
    /// - Parameter enableShake: enable shake to show alert when shaking device
    public init(enableShake: Bool, outputQueue: DispatchQueue = .defaultLoggingQueue()) {
        
        super.init(outputQueue: outputQueue)
        self.shakeEnabled = enableShake
        
        _ = NotificationCenter.default.addObserver(forName: Notification.Name.loggerDidShake, object: nil, queue: nil) { [weak self] (_) in
            self?.didShake()
        }
    }
    
    
    // MARK: - Override
    
    public override func writeOutput(level: LogLevel?, string: String) {
        
        self.outputQueue.async {
            super.writeOutput(level: level, string: string)
            
            DispatchQueue.main.async {
                // UI operation, has to be called on main thread
                self.updateTextView(string)
            }
		}
    }
    
    
    // MARK: - Enable/Disable
    
    private func didShake() {
        
        if self.loggerWindow != nil {
            self.enableTouch(enabled: false)
        } else if self.shakeEnabled {
            self.show()
        }
    }
    
    
    // MARK: - Window handling
    
    private func addWindow() {
        
        if self.loggerWindow != nil {
            return
        }
        
        self.loggerWindow = UIWindow(frame: UIScreen.main.bounds)
        self.loggerWindow?.windowLevel = UIWindow.Level.alert
        self.loggerWindow?.isHidden = false
        
        let rootVC = UIViewController()
        self.loggerWindow?.rootViewController = rootVC
    }
    
    
    // MARK: - Show
    
    public func show() {
        
        self.addWindow()
        self.showDebugAlert()
    }
    
    
    private func showDebugAlert() {
        
        let title = "\(Bundle.main.bundleAppDisplayName())"
        let message = "v\(Bundle.main.bundleShortVersion()) Build \(Bundle.main.bundleBuildVersion())"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Strings.currentLog, style: .default, handler: { [unowned self] (_) -> Void in
                
            self.showLog(log: .current)
        }))
        
        if LogFile.previous.data != nil {
            
            alertController.addAction(UIAlertAction(title: Strings.prevLog, style: .default, handler: { [unowned self] (_) -> Void in
                self.showLog(log: .previous)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: Strings.share, style: .default, handler: { [unowned self] (_) -> Void in
            self.shareButtonTapped()
        }))
        
        alertController.addAction(UIAlertAction.init(title: Strings.cancel, style: .cancel, handler: { [unowned self] (_) -> Void in
            self.closeButtonTapped()
        }))
        self.loggerWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    private func showLog(log: LogFile) {
        
        guard let data = log.data else {
            return
        }
        
        self.visibleLogFile = log
        
        self.addContainerView()
        self.addStackView()
        self.addButtons()
        self.addTextView()
        
        let logText = String(data: data, encoding: String.Encoding.utf8)
        self.textView?.text = logText
        
        self.textView?.isScrollEnabled = false
        self.textView?.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
        self.textView?.isScrollEnabled = true
    }
    
    
    // MARK: - Setup UI
    
    private func addContainerView() {
        
        self.containerView = UIView(frame: UIScreen.main.bounds)
        self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.containerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.loggerWindow?.rootViewController?.view.addSubview(self.containerView!)
        
        self.contentStackView = UIStackView(frame: self.containerView!.bounds)
        self.contentStackView?.axis = .vertical
        self.contentStackView?.distribution = .fill
        self.containerView?.addSubview(self.contentStackView!)
        
        self.contentStackView?.translatesAutoresizingMaskIntoConstraints = false
        self.contentStackView?.leftAnchor.constraint(equalTo: self.containerView!.leftAnchor).isActive = true
        self.contentStackView?.rightAnchor.constraint(equalTo: self.containerView!.rightAnchor).isActive = true
        self.contentStackView?.bottomAnchor.constraint(equalTo: self.containerView!.bottomAnchor).isActive = true
            
        guard let guide = self.containerView?.safeAreaLayoutGuide else {
            return
        }
    
        self.contentStackView?.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1).isActive = true
    }
    
    
    private func addStackView() {
        
        self.buttonStackView = UIStackView()
        self.buttonStackView?.axis = .horizontal
        self.buttonStackView?.distribution = .fillEqually
        self.contentStackView?.addArrangedSubview(self.buttonStackView!)
    }
    
    
    private func addButtons() {
        
        let closeButton = self.addDefaultButton(Strings.close, action: #selector(self.closeButtonTapped))
        self.buttonStackView?.addArrangedSubview(closeButton)
        
        let touchButton = self.addDefaultButton(Strings.touch, action: #selector(self.touchButtonTapped))
        self.buttonStackView?.addArrangedSubview(touchButton)
        
        let shareButton = self.addDefaultButton(Strings.share, action: #selector(self.shareButtonTapped))
        self.buttonStackView?.addArrangedSubview(shareButton)
    }
    
    private func addDefaultButton(_ title: String, action: Selector) -> UIButton {
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    private func addTextView() {
        
        self.textView = UITextView()
        self.textView?.backgroundColor = UIColor.clear
        self.textView?.textColor = UIColor.white
        self.textView?.isEditable = false
        self.textView?.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.textView?.textContainer.lineFragmentPadding = 0
        self.contentStackView?.addArrangedSubview(self.textView!)
    }
    
    
    private func updateTextView(_ output: String) {
        
        guard let textView = self.textView else {
            return
        }
        
        guard let log = self.visibleLogFile, log == .current else {
            return
        }
        
        var shouldScrollDown = false
        if textView.contentOffset.y >= textView.contentSize.height - textView.frame.size.height - 20 {
            shouldScrollDown = true
        }
        
        textView.text.append("\n" + output)
        
        if shouldScrollDown {
            
            // workaround for textView offset
            textView.isScrollEnabled = false
            textView.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
            textView.isScrollEnabled = true
        }
    }
    
    
    private func enableTouch(enabled: Bool) {
        
        self.loggerWindow?.isUserInteractionEnabled = !enabled
        self.containerView?.isUserInteractionEnabled = !enabled
        let alpha: CGFloat = enabled ? 0.5 : 0.9
        self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        self.buttonStackView?.isHidden = enabled
    }
    
    
    // MARK: - Button actions
    
    @objc private func closeButtonTapped() {
        
        self.visibleLogFile = nil
        self.textView?.removeFromSuperview()
        self.textView = nil
        self.contentStackView?.removeFromSuperview()
        self.contentStackView = nil
        self.containerView?.removeFromSuperview()
        self.containerView = nil
        self.loggerWindow?.isHidden = true
        self.loggerWindow = nil
    }
    
    
    @objc private func shareButtonTapped() {
        
        var fileURLs = [Any]()
        
        let currentLogURL = LogFile.current.url
        fileURLs.append(currentLogURL)
        
        let prevLogURL = LogFile.previous.url
        fileURLs.append(prevLogURL)
        
        let shareSheet = UIActivityViewController(activityItems: fileURLs, applicationActivities: nil)
        shareSheet.setValue("Logfiles", forKey: "subject")
        shareSheet.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList,
                                            UIActivity.ActivityType.message,
                                            UIActivity.ActivityType.assignToContact,
                                            UIActivity.ActivityType.postToFlickr,
                                            UIActivity.ActivityType.postToTencentWeibo,
                                            UIActivity.ActivityType.postToVimeo]
        shareSheet.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            if self.contentStackView == nil {
                self.closeButtonTapped()
            }
        }
        
        if let v = self.loggerWindow?.rootViewController?.view {
            
            shareSheet.popoverPresentationController?.sourceView = v
            shareSheet.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height, width: 1, height: 1)
            self.loggerWindow?.rootViewController?.present(shareSheet, animated: true, completion: nil)
        }
    }
    
    
    @objc private func touchButtonTapped() {
        
        guard self.contentStackView != nil else {
            return
        }
        
        let alert = UIAlertController(title: Strings.touchEnabled, message: Strings.touchMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: { (_) in
            
            self.enableTouch(enabled: true)
        }))
        self.loggerWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
