//
//  PictureOfTheDayViewController.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/27/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import UIKit

class APODViewController: UIViewController {
    @IBOutlet weak var podImageView: UIImageView!
    @IBOutlet weak var podImageTitle: UILabel!
    static let apodURL = "https://api.nasa.gov/planetary/apod?api_key=NNKOjkoul8n1CH18TWA9gwngW1s1SmjESPjNoUFo"
    weak var activePODImageView: UIImageView!
    var isFullScreenEnabled: Bool!
    var progressHUD: ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /* //Uncomment this line if we want to reload the page after App's transition from background to foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
         */
        //podImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.startAPODDownload()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let newImageView = self.activePODImageView{
            var bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            newImageView.superview?.frame = bounds
            if(!isFullScreenEnabled)
            {
                bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height/2)
            }
            self.scaleAPODImageView(imageView: newImageView, bounds: bounds)
            positionAPODTitle()
        }
    }
    
    @IBAction func apodImageTapped(_ sender: UITapGestureRecognizer) {
        self.podImageTitle.fadeOut(completion: {
            (finished: Bool) -> Void in
                let imageView = sender.view as! UIImageView
                let newImageView = UIImageView(image: imageView.image)
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.activePODImageView = newImageView
                self.isFullScreenEnabled = true
                self.scaleAPODImageView(imageView: newImageView, bounds: UIScreen.main.bounds)
            })
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
        //Reposition the original picture of the day
        self.activePODImageView=self.podImageView
        let bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        self.scaleAPODImageView(imageView: self.activePODImageView, bounds: bounds)
        self.isFullScreenEnabled = false
        self.positionAPODTitle()
        self.podImageTitle.fadeIn()
    }
    
    @objc func appWillEnterForeground() {
        self.startAPODDownload()
    }
    
    func startAPODDownload(){
        self.podImageTitle.isHidden = true
        self.isFullScreenEnabled = false
        progressHUD = ProgressHUD(text: "Downloding")
        self.view.addSubview(progressHUD)
        DispatchQueue.global().async {
            let apodRestAPIAdapter = APODRestAPIAdapter(strUrl: APODViewController.apodURL)
            apodRestAPIAdapter.download(completionHandler: self.onAPODDownloadCompleted)
        }
        
    }
    
    func onAPODDownloadCompleted(apodModel: APODModel, error: String, success: Bool)-> Void{
        if(success){
            let mediaHandler = APODModelStrategy.getMediaHandle(mediaType: apodModel.media_type!)
            mediaHandler.handle(strUrl: apodModel.url!, completionHandler: onMediaDownloadCompleted)
            DispatchQueue.main.async {
                self.podImageTitle.text = apodModel.title
            }
        }
        else{
            self.onDownloadError(title:"Error downloding APOD data", description: error)
        }
    }
    
    func onMediaDownloadCompleted(mediaData: Media, error: String, success: Bool)
    {
        if(success){//It will only be success for media type Image
            if(mediaData.getMediaType() == MediaType.image){
                let image = UIImage(data: mediaData.getMediaData())
                if(image != nil)
                {
                    DispatchQueue.main.async {
                        self.podImageView.image = image
                        self.activePODImageView = self.podImageView
                        let bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                        self.scaleAPODImageView(imageView: self.activePODImageView, bounds: bounds)
                        self.progressHUD?.removeFromSuperview()
                        self.podImageTitle.isHidden = false;
                        self.positionAPODTitle()
                    }
                }
            }
        }
        else{
            Logger.log(message: error, event: .e) // Error
            self.onDownloadError(title: "Failed to download media data", description: error)
            
        }
    }
    
    func onDownloadError(title: String, description: String){
        Logger.log(message: "Response string: \(description)", event: .e) // Error
        DispatchQueue.main.sync {
            // create the alert
            let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            self.progressHUD?.removeFromSuperview()
            self.podImageTitle.isHidden = true
            self.podImageView.isUserInteractionEnabled = false
        }
    }
    func positionAPODTitle()
    {
        let imageRect = self.podImageView.frame
        var lblRect = self.podImageTitle.frame
        lblRect.origin.y = imageRect.origin.y+imageRect.height+5
        lblRect.size.width = imageRect.width
        Logger.log(message: "\(String(describing: self.podImageTitle.text)) requires \(self.podImageTitle.numberOfVisibleLines(newRect: lblRect))", event: .d)
        let requiredLines = self.podImageTitle.numberOfVisibleLines(newRect: lblRect)
        lblRect.size.height = 21 * CGFloat(requiredLines) //21 is the default height
        self.podImageTitle.frame = lblRect
        self.podImageTitle.center.x = imageRect.width/2
        
    }
    func scaleAPODImageView(imageView: UIImageView, bounds: CGRect)
    {
        imageView.frame = bounds
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.center = (imageView.superview?.center)!
    }
    
}







