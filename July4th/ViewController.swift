import UIKit
import MapKit
import CoreLocation
import AVFoundation

var animateView: UIView = UIView()
var rootLayer: CALayer = CALayer()
var mortor: CAEmitterLayer = CAEmitterLayer()
var mainView: UIView = UIView()
var mainMapView: UIView = UIView()
var menuView: UIView = UIView()
var disclaimerView: UIView = UIView()
var splashView: UIImageView = UIImageView()
var introImageView: UIImageView = UIImageView()
var rightBtn: UIButton = UIButton()
var leftBtn: UIButton = UIButton()
var homeBtn: UIButton = UIButton()
var playBtn: UIButton = UIButton()
var pauseBtn: UIButton = UIButton()
var locationBtn: UIButton = UIButton()
var dataSource: NSString = "Points"
var mapDisplay: NSString = "Off"
var menuDisplay: NSString = "Off"
var gpsDisplay: NSString = "Off"
var fireworkDisplay: NSString = "Off"
var destinationTime: NSString = ""
var locateMeLabel: UILabel = UILabel()
var appTitle: UILabel = UILabel()
var finalCountLabel: UILabel = UILabel()
var timer: Timer = Timer()
var timer1: Timer = Timer()
var timer2: Timer = Timer()
var timer3: Timer = Timer()
var timer4: Timer = Timer()
var seconds: NSInteger = NSInteger()
var sliderValues: float_t = float_t()
var introText: UITextView = UITextView()
var disclaimerText: UITextView = UITextView()
var check: Bool = true
var musicPlay: Bool = false
var disclaimerBtn: UIButton = UIButton()
var checkBtn: UIButton = UIButton()
var scrollLabel: UILabel = UILabel()
var isHighLighted:Bool = false
var myActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
var slider: UISlider = UISlider()

let menus = ["Become a Sponsor", "Contact Us", "Directions & Transportation", "Event Map", "Event Merchandise", "FAQ", "Merriments", "Program Guide", "Terms and Conditions"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeModelProtocal,MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIWebViewDelegate {
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    
    var tableView: UITableView = UITableView()
    var selectedIndexPath : IndexPath?
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var webView: UIWebView = UIWebView()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.activityType = .automotiveNavigation
        locationManager.requestWhenInUseAuthorization()
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems("Points")
        
        view.backgroundColor=UIColor(red: 32/255, green: 32/255, blue: 64/255, alpha: 1)
        
        mainView=UIView(frame: CGRect(x: 0, y: 85, width: view.frame.width, height: view.frame.height-85))
        mainView.backgroundColor=UIColor(red: 32/255, green: 64/255, blue: 128/255, alpha: 1)
        view.addSubview(mainView)
        
        animateView=UIView(frame: CGRect(x: 0, y: 85, width: view.frame.width, height: view.frame.height-212))
        animateView.backgroundColor=UIColor.clear
        animateView.alpha = 0
        view.addSubview(animateView)
        
        createNavigationBar()
        createIntroduction()
        
        if CLLocationManager.locationServicesEnabled() {
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        createScrollLabel()
        
        menuView = UIView(frame: CGRect(x: -(mainView.frame.width), y: 0, width: mainView.frame.width, height: mainView.frame.height))
        menuView.backgroundColor=UIColor(red: 32/255, green: 64/255, blue: 128/255, alpha: 1)
        menuView.tag = 1
        mainView.addSubview(menuView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 10, width: mainView.frame.width-20, height: mainView.frame.height-20), style: UITableViewStyle.plain)
        tableView.backgroundColor=UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuView.addSubview(self.tableView)
        
        createWebAndMapView()
        
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        splashView  = UIImageView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height));
        splashView.image = UIImage(named:"Default.png")
        splashView.alpha = 1
        view.addSubview(splashView)
        
        createDisclaimer()

    }
    //# MARK: - Navigation Bar
    func createNavigationBar() {
        leftBtn = UIButton(type: UIButtonType.system) as UIButton
        leftBtn.frame = CGRect(x: 5, y: 32, width: 40, height: 48)
        leftBtn.setImage(UIImage(named: "List_White.png"), for:UIControlState())
        leftBtn.tintColor = UIColor.white
        leftBtn.addTarget(self, action: #selector(ViewController.leftBtnPress), for:.touchUpInside)
        view.addSubview(leftBtn)
        
        rightBtn = UIButton(type: UIButtonType.system) as UIButton
        rightBtn.frame = CGRect(x: view.frame.width-45, y: 30, width: 28, height: 28)
        rightBtn.setImage(UIImage(named: "Map_Tab.png"), for:UIControlState())
        rightBtn.tintColor = UIColor.white
        rightBtn.addTarget(self, action: #selector(ViewController.rightBtnPress), for:.touchUpInside)
        view.addSubview(rightBtn)
        
        homeBtn = UIButton(type: UIButtonType.system) as UIButton
        homeBtn.frame = CGRect(x: 15, y: 30, width: 24, height: 24)
        homeBtn.setImage(UIImage(named: "750-home.png"), for:UIControlState())
        homeBtn.tintColor = UIColor.white
        homeBtn.isHidden = true
        homeBtn.addTarget(self, action: #selector(ViewController.homePress), for:.touchUpInside)
        view.addSubview(homeBtn)
        
        appTitle = UILabel(frame: CGRect(x: 10, y: 30, width: view.frame.width-20, height: 24))
        appTitle.text = "July 4th"
        appTitle.textColor=UIColor.white
        appTitle.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        appTitle.textAlignment = NSTextAlignment.center
        view.addSubview(appTitle)
        
        //createTabBar()
    }
    func homePress() {
        self.stopCountDown()
        appTitle.text = "July 4th"
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        mapDisplay = "Off"
        leftBtn.isHidden = false
        homeBtn.isHidden = true
        UIView.animate(withDuration: 1, animations:  {() in
            rightBtn.tintColor = UIColor.white
            menuView.frame = CGRect(x: -(mainView.frame.width), y: 0, width: menuView.frame.width, height: menuView.frame.height)
            self.webView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
            mainMapView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
            }, completion:{(Bool)  in
        })
        getMessage()
        var bounds: CGRect = scrollLabel.bounds
        let originalString: String = scrollLabel.text!
        let myString: NSString = originalString as NSString
        bounds.size = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        scrollLabel.bounds = bounds;
    }
    func leftBtnPress() {
        self.stopCountDown()
        appTitle.text = "July 4th"
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        selectedIndexPath = nil
        mapDisplay = "Off"
        dataSource = "Others"
        myActivityIndicator.startAnimating()
        rightBtn.tintColor = UIColor.white
        leftBtn.isHidden = true
        homeBtn.isHidden = false
        if menuDisplay == "On" {
            UIView.animate(withDuration: 1, animations:  {() in
                menuView.alpha = 0
                menuView.frame = CGRect(x: -(mainView.frame.width), y: 0, width: mainView.frame.width-60, height: mainView.frame.height)
                self.webView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                mainMapView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                }, completion:{(Bool)  in
                    let homeModel = HomeModel()
                    homeModel.delegate = self
                    homeModel.downloadItems("Others")
                    
                    menuView.backgroundColor=UIColor(red: 32/255, green: 64/255, blue: 128/255, alpha: 1)
                    menuView.frame = CGRect(x: -(mainView.frame.width), y: 0, width: mainView.frame.width, height: mainView.frame.height)
                    UIView.animate(withDuration: 1.0, animations: {() in
                        menuView.alpha = 1
                        leftBtn.tintColor = UIColor.white
                        menuView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                        self.tableView.frame = CGRect(x: 0, y: 10, width: menuView.frame.width-20, height: menuView.frame.height-20)
                        }, completion:{(Bool) in
                            menuDisplay = "Off"
                    })
            })
        } else if menuDisplay == "Off" {
            UIView.animate(withDuration: 1, animations:  {() in
                let homeModel = HomeModel()
                homeModel.delegate = self
                homeModel.downloadItems("Others")
                menuView.backgroundColor=UIColor(red: 32/255, green: 64/255, blue: 128/255, alpha: 1)
                menuView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                self.webView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                mainMapView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                }, completion:{(Bool)  in
                    UIView.animate(withDuration: 1.0, animations: {() in
                        menuView.alpha = 1
                        leftBtn.tintColor = UIColor.white
                        menuView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                        self.tableView.frame = CGRect(x: 0, y: 10, width: menuView.frame.width-20, height: menuView.frame.height-20)
                        }, completion:{(Bool) in
                            menuDisplay = "Off"
                    })
            })
        }
    }
    func rightBtnPress() {
        self.stopCountDown()
        appTitle.text = "July 4th"
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        leftBtn.tintColor = UIColor.white
        if mapDisplay == "Off" {
            mapDisplay = "On"
            menuDisplay = "Off"
            rightBtn.tintColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1)
            UIView.animate(withDuration: 1.0, animations: {
                leftBtn.isHidden = true
                homeBtn.isHidden = false
                menuView.frame = CGRect(x: -(mainView.frame.width), y: 0, width: mainView.frame.width-60, height: mainView.frame.height)
                self.webView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                mainMapView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
                
            })
        } else if mapDisplay == "On" {
            mapDisplay = "Off"
            rightBtn.tintColor = UIColor.white
            UIView.animate(withDuration: 1.0, animations: {
                leftBtn.isHidden = false
                homeBtn.isHidden = true
                mainMapView.frame = CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height)
            })
        }
    }
    func closeSlide() {
        leftBtn.tintColor = UIColor.white
        menuDisplay = "Off"
        UIView.animate(withDuration: 1.0, animations: {
            menuView.frame = CGRect(x: -(mainView.frame.width), y: 0, width: mainView.frame.width-60, height: mainView.frame.height)
        })
    }
    //# MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == "Slide" {
            return menus.count
        } else {
            return feedItems.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource == "Slide" {
            return 35
        } else {
            if indexPath == selectedIndexPath {
                return MyTableViewCell.expandedHeight
            } else {
                return MyTableViewCell.defaultHeight
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        let item: LocationModel = feedItems[(indexPath as NSIndexPath).row] as! LocationModel
        cell.myButton1.frame = CGRect(x: 15, y: 8, width: 30, height: 30)
        cell.myButton1.setImage(UIImage(named: (item.category! as String)+".png"), for: UIControlState())
        cell.myLabel1.frame = CGRect(x: 55, y: 10, width: tableView.frame.width-50, height: 24)
        cell.myLabel1.text = item.name
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item: LocationModel = feedItems[(indexPath as NSIndexPath).row] as! LocationModel
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
        mapView.centerCoordinate = center
        let span = MKCoordinateSpanMake(0.0015, 0.0015)
        let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = item.name
        
        mapView.addAnnotation(annotation)
        
        rightBtnPress()

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MyTableViewCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MyTableViewCell).ignoreFrameChanges()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [MyTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }

    func openMap() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        let item: LocationModel = feedItems[(selectedIndexPath! as NSIndexPath).row] as! LocationModel
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
        mapView.centerCoordinate = center
        let span = MKCoordinateSpanMake(0.0015, 0.0015)
        let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = item.name
        
        mapView.addAnnotation(annotation)
        
        rightBtnPress()
    }
    func getMessage() {
        let url: URL = URL(string: "https://gis.howardcountymd.gov/iOS/July4th/GetScrollMessage.aspx")!
        let data: Data = try! Data(contentsOf: url)
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            var jsonElement: NSDictionary = NSDictionary()
            
            jsonElement = jsonResult[0] as! NSDictionary
            let messages = (jsonElement["Messages"] as? String)!
            scrollLabel.text = messages

        } catch let error as NSError {
            print(error)
        }
    }
    //# MARK: - Scroll Label
    func createScrollLabel() {
        scrollLabel = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 22))
        scrollLabel.text = ""
        scrollLabel.textColor=UIColor.white
        scrollLabel.backgroundColor=UIColor(red: 32/255, green: 32/255, blue: 64/255, alpha: 1)
        scrollLabel.font = UIFont(name: "TrebuchetMS", size: 14)
        scrollLabel.textAlignment = NSTextAlignment.center
        scrollLabel.alpha = 1
        self.view.addSubview(scrollLabel)
        
        getMessage()
        
        var bounds: CGRect = scrollLabel.bounds
        let originalString: String = scrollLabel.text!
        let myString: NSString = originalString as NSString
        bounds.size = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        scrollLabel.bounds = bounds;
        
    }
    func timeScroll() {
        scrollLabel.center = CGPoint(x: scrollLabel.center.x-2, y: scrollLabel.center.y);
        if (scrollLabel.center.x < -(scrollLabel.bounds.size.width/2)) {
            scrollLabel.center = CGPoint(x: self.view.frame.size.width + (scrollLabel.bounds.size.width/2), y: scrollLabel.center.y);
        }
    }
    //# MARK: - Agreement
    func checkAgree() {
        let prefs = UserDefaults.standard
        let agreeItem = prefs.string(forKey: "Agreement")
        if agreeItem == "Yes" {
            closeDisclaimer()
        } else if agreeItem == "No" {
            openDisclaimer()
        } else {
            openDisclaimer()
        }
    }
    func createIntroduction() {
        introImageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: mainView.frame.width, height: 80));
        introImageView.image = UIImage(named:"4thjuly.jpg")
        introImageView.alpha = 1
        mainView.addSubview(introImageView)
        
        introText = UITextView(frame: CGRect(x: 10, y: 90, width: mainView.frame.width-20, height: mainView.frame.height-140))
        introText.text = "\nDate: Monday, July 4, 2016, 5-10 PM\nFireworks at Dusk\nRain date: Tuesday, July 5 (Fireworks Only)\nInclement weather line: 410-313-4451\n\nCounty Executive Allan H. Kittleman Invites You to the Columbia Lakefront for an Evening of Family Fun and Fireworks!\n\nNote: Those wishing to place a blanket or sheet may do so beginning at 8 AM on July 4. Those wishing to place a tarp on the grass may do so beginning at 3 PM. Placement of tarps must wait until 3 PM in order to protect the grass. For more information on your tarp, contact the Columbia Association at 410-312-6330. No boats are permitted on the lake July 3-5. We encourage all attendees to arrive early to avoid traffic congestion.\n\nLittle Patuxent Parkway will be closed at approximately 6:30-7:30 PM and is not to be reopened until the conclusion of the fireworks."
        introText.textColor=UIColor.white
        introText.font = UIFont(name: "TrebuchetMS", size: 14)
        introText.backgroundColor=UIColor.clear
        introText.alpha = 0
        introText.dataDetectorTypes = UIDataDetectorTypes.all
        introText.tintColor = UIColor.cyan
        introText.isSelectable = true
        introText.isEditable = false
        mainView.addSubview(introText)
        
        finalCountLabel = UILabel(frame: CGRect(x: 0, y: (animateView.frame.size.height/2), width: animateView.frame.width, height: 200))
        finalCountLabel.text = "130"
        finalCountLabel.textColor=UIColor.green
        finalCountLabel.font = UIFont(name: "digital-7", size: 200)
        finalCountLabel.textAlignment = NSTextAlignment.center
        finalCountLabel.isHidden = true
        self.view.addSubview(finalCountLabel)
        
        slider = UISlider(frame:CGRect(x: 20, y: mainView.frame.height-70, width: mainView.frame.width-40, height: 20))
        slider.minimumValue = 0
        slider.maximumValue = 1280
        slider.isContinuous = false
        slider.tintColor = UIColor.red
        slider.value = 0
        slider.isHidden = true
        slider.isEnabled = false
        mainView.addSubview(slider)
        
        playBtn = UIButton(type: UIButtonType.system) as UIButton
        playBtn.frame = CGRect(x: (mainView.frame.width/2)-14, y: mainView.frame.height-40, width: 28, height: 28)
        playBtn.setImage(UIImage(named: "461-play1.png"), for:UIControlState())
        playBtn.tintColor = UIColor.white
        playBtn.isHidden = false
        playBtn.addTarget(self, action: #selector(ViewController.playPress), for:.touchUpInside)
        mainView.addSubview(playBtn)
    }
    func playPress() {
        if fireworkDisplay == "Off" {
            self.startCountDown()
        } else if fireworkDisplay == "On" {
            self.stopCountDown()
        }
    }
    func startCountDown() {
        fireworkDisplay = "On"
        UIView.animate(withDuration: 1.0, animations: {() in
            introImageView.alpha = 0
            introText.alpha = 0
            playBtn.setImage(UIImage(named: "462-pause1.png"), for:UIControlState())
            mainView.backgroundColor=UIColor.black
            animateView.alpha = 1
            }, completion:{(Bool) in
                finalCountLabel.isHidden = true
                finalCountLabel.text = "130"
                slider.value = 0
                slider.isHidden = false
                sliderValues = 0
                seconds = 130
                timer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.countDownTime), userInfo: nil, repeats: false)
                self.startAudio()
        })
    }
    func stopCountDown() {
        fireworkDisplay = "Off"
        UIView.animate(withDuration: 1.0, animations: {() in
            introImageView.alpha = 1
            introText.alpha = 1
            playBtn.setImage(UIImage(named: "461-play1.png"), for:UIControlState())
            mainView.backgroundColor=UIColor(red: 32/255, green: 64/255, blue: 128/255, alpha: 1)
            animateView.alpha = 0
            }, completion:{(Bool) in
                timer2.invalidate()
                timer3.invalidate()
                timer4.invalidate()
                slider.isHidden = true
                finalCountLabel.isHidden = true
                if musicPlay {
                    self.audioPlayer.stop()
                    musicPlay = false
                }
                mortor.removeFromSuperlayer()
        })
    }
    func startAudio() {
        let julySound = Bundle.main.path(forResource: "2016 Howard County 8666 V3", ofType: "mp3")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: julySound!), fileTypeHint: nil)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            musicPlay = true
        }catch {
            print("Error getting the audio file")
        }
    }
    func countDownTime() {
        //timer3 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
        awakeFromNib()
        sliderValues = 0
        timer4 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.playSlider), userInfo: nil, repeats: true)
    }
    func playSlider() {
        sliderValues=sliderValues+1
        slider.value = sliderValues
        if (sliderValues == 1208) {
            self.stopCountDown()
        }
    }
    func subtractTime() {
        seconds=seconds-1
        finalCountLabel.text = "\(seconds)"
        if seconds == 0 {
            timer3.invalidate()
            finalCountLabel.isHidden = true
            finalCountLabel.text = "130"
            awakeFromNib()
        }
    }
    func createDisclaimer() {
        disclaimerView=UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        disclaimerView.backgroundColor=UIColor.gray
        self.view.addSubview(disclaimerView)
        
        let disclaimerLabel = UILabel(frame: CGRect(x: 10, y: 30, width: disclaimerView.frame.width-20, height: 24))
        disclaimerLabel.text = "Terms and Conditions"
        disclaimerLabel.textColor=UIColor.white
        disclaimerLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        disclaimerLabel.textAlignment = NSTextAlignment.center
        disclaimerView.addSubview(disclaimerLabel)
        
        disclaimerText = UITextView(frame: CGRect(x: 10, y: 60, width: disclaimerView.frame.width-20, height: disclaimerView.frame.height-172))
        disclaimerText.text = "Your access to and use of the Howard County Government website (the 'Site') is subject to the following terms and conditions, as well as all applicable laws. Your access to the Site is in consideration for your agreement to these Terms and Conditions of Use, whether or not you are a registered user. By accessing, browsing, and using the Site, you accept, without limitation or qualification, these Terms and Conditions of Use.\n\nThere are sections of the Howard County Government website that connect you to other sites outside of the control of the Howard County Government. These terms and conditions apply only to those areas that are registered under the Howard County Government name and its agencies. Refer to the Terms of Use for those sites outside of the Howard County Government control.\n\nModification of the Agreement\n\nHoward County Government maintains the right to modify these Terms and Conditions of Use and may do so by posting notice of such modifications on this page. Any modification is effective immediately upon posting the modification unless otherwise stated. Your continued use of the Site following the posting of any modification signifies your acceptance of such modification. You should periodically visit this page to review the current Terms and Conditions of Use.\n\nConduct\n\nYou agree to access and use the Site only for lawful purposes. You are solely responsible for the knowledge of and adherence to any and all laws, statutes, rules and regulations pertaining to your use of the Site. By accessing the Site, you agree that you will not:\n\nUse the Site to commit a criminal offense or to encourage others to conduct that which would constitute a criminal offense or give rise to a civil liability;\nPost or transmit any unlawful, threatening, libelous, harassing, defamatory, vulgar, obscene, pornographic, profane, or otherwise objectionable content;\nUse the Site to impersonate other parties or entities;\nUse the Site to upload any content that contains a software virus, 'Trojan Horse' or any other computer code, files, or programs that may alter, damage, or interrupt the functionality of the Site or the hardware or software of any other person who accesses the Site;\nUpload, post, email, or otherwise transmit any materials that you do not have a right to transmit under any law or under a contractual relationship;\nAlter, damage, or delete any content posted on the site;\nDisrupt the normal flow of communication in any way;\nClaim a relationship with or speak for any business, association, or other organization for which you are not authorized to claim such a relationship;\nPost or transmit any unsolicited advertising, promotional materials, or other forms of solicitation;\nPost any material that infringes or violates the intellectual property rights of another; or\nCollect or store personal information about others.\n\nTermination of Use\n\nHoward County Government may, in its sole discretion, terminate or suspend your access and use of this Site without notice and for any reason, including for violation of these Terms and Conditions of Use or for other conduct which the Howard County Government, in its sole discretion, believes is unlawful or harmful to others. In the event of termination, you are no longer authorized to access the Site, and the Howard County Government will use whatever means possible to enforce this termination.\n\nOther Site Links\n\nSome links on the Site lead to websites that are not operated by the Howard County Government. The Howard County Government does not control these websites nor do we review or control their content. The Howard County Government provides these links to users for convenience. These links are not an endorsement of products, services, or information, and do not imply an association between the Howard County Government and the operators of the linked website.\n\nPolicy on Spamming\n\nYou specifically agree that you will not utilize email addresses obtained through using the Howard County Government's website to transmit the same or substantially similar unsolicited message to 10 or more recipients in a single day, nor 20 or more emails in a single week (consecutive 7-day period), unless it is required for legitimate business purposes. The Howard County Government, in its sole and exclusive discretion, will determine violations of the limitations on email usage set forth in these Terms and Conditions of Use.\n\nContent\n\nThe Howard County Government has the right to monitor the content that you provide, but shall not be obligated to do so. Although the Howard County Government cannot monitor all postings on the Site, we reserve the right (but assume no obligation) to delete, move, or edit any postings that come to our attention that we consider unacceptable or inappropriate, whether for legal or other reasons. United States and foreign copyright laws and international conventions protect the contents of the Site. You agree to abide by all copyright notices.\n\nIndemnity\n\nYou agree to defend, indemnify, and hold harmless the Howard County Government and its employees from any and all liabilities and costs incurred by Indemnified Parties in connection with any claim arising from any breach by you of these Terms and Conditions of Use, including reasonable attorneys' fees and costs. You agree to cooperate as fully as may be reasonably possible in the defense of any such claim. The Howard County Government reserves the right to assume, at its own expense, the exclusive defense and control of any matter otherwise subject to indemnification by you. You in turn shall not settle any matter without the written consent of the Howard County Government.\n\nDisclaimer of Warranty\n\nYou expressly understand and agree that your use of the Site, or any material available through this Site, is at your own risk. Neither the Howard County Government nor its employees warrant that the Site will be uninterrupted, problem-free, free of omissions, or error-free; nor do they make any warranty as to the results that may be obtained from the use of the Site. The content and function of the Site are provided to you 'as is,' without warranties of any kind, either express or implied, including, but not limited to, warranties of title, merchantability, fitness for a particular purpose or use, or 'currentness.'\n\nLimitation of Liability\n\nIn no event will the Howard County Government or its employees be liable for any incidental, indirect, special, punitive, exemplary, or consequential damages, arising out of your use of or inability to use the Site, including without limitation, loss of revenue or anticipated profits, loss of goodwill, loss of business, loss of data, computer failure or malfunction, or any and all other damages."
        disclaimerText.textColor=UIColor.white
        disclaimerText.font = UIFont(name: "TrebuchetMS", size: 12)
        disclaimerText.backgroundColor=UIColor.darkGray
        disclaimerText.alpha = 1
        disclaimerText.isSelectable = false
        disclaimerText.isEditable = false
        disclaimerView.addSubview(disclaimerText)
        
        checkBtn = UIButton(type: UIButtonType.system) as UIButton
        checkBtn.frame = CGRect(x: 10, y: disclaimerView.frame.size.height-90, width: 32, height: 32)
        checkBtn.setImage(UIImage(named: "Uncheckbox.png"), for:UIControlState())
        checkBtn.addTarget(self, action: #selector(ViewController.btnTouched), for:.touchUpInside)
        disclaimerView.addSubview(checkBtn)
        
        let agreeLabel = UILabel(frame: CGRect(x: 52, y: disclaimerView.frame.size.height-85, width: 100, height: 24))
        agreeLabel.text = "I agree"
        agreeLabel.textColor=UIColor.white
        agreeLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        agreeLabel.textAlignment = NSTextAlignment.left
        disclaimerView.addSubview(agreeLabel)
        
        disclaimerBtn = UIButton(frame: CGRect(x: 10, y: disclaimerView.frame.height-50, width: disclaimerView.frame.width-20, height: 40))
        disclaimerBtn.setTitle("Accept and Continue", for: UIControlState())
        disclaimerBtn.setTitleColor(UIColor.white, for: UIControlState())
        disclaimerBtn.titleLabel!.font = UIFont(name: "TrebuchetMS", size: 20)
        disclaimerBtn.addTarget(self, action: #selector(ViewController.closeDisclaimer), for: .touchUpInside)
        disclaimerBtn.backgroundColor=UIColor.lightGray
        disclaimerBtn.isHidden = true
        disclaimerView.addSubview(disclaimerBtn)
        
        checkAgree()
    }
    func openDisclaimer() {
        UIView.animate(withDuration: 1.0, animations: {
            disclaimerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    func closeDisclaimer() {
        let prefs = UserDefaults.standard
        prefs.setValue("Yes", forKey: "Agreement")
        UIView.animate(withDuration: 1, animations: {
            disclaimerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.splash), userInfo: nil, repeats: false)
        })
    }
    func splash() {
        timer.invalidate()
        UIView.animate(withDuration: 1.0, animations: {
            introText.alpha = 1
            splashView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            myActivityIndicator.stopAnimating()
        })
        timer1 = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(ViewController.timeScroll), userInfo: nil, repeats: true)
    }
    func btnTouched() {
        if check==false {
            let prefs = UserDefaults.standard
            prefs.setValue("No", forKey: "Agreement")
            check=true
            disclaimerBtn.isHidden = true
            checkBtn.setImage(UIImage(named: "Uncheckbox.png"), for: UIControlState())
        } else if check==true {
            let prefs = UserDefaults.standard
            prefs.setValue("Yes", forKey: "Agreement")
            check=false
            disclaimerBtn.isHidden = false
            checkBtn.setImage(UIImage(named: "Checkedbox.png"), for: UIControlState())
        }
    }
    //# MARK: - Update Data
    func itemsDownloaded(_ items: NSArray) {
        feedItems = items
        if dataSource == "Points" {
            setPin()
        } else {
            tableView.reloadData()
            myActivityIndicator.stopAnimating()
        }
    }
    //# MARK: - Set Pin
    func removePin() {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
    }
    func setPin() {
        for obj : AnyObject in feedItems as [AnyObject] {
            if let item: LocationModel = obj as? LocationModel {
                let title = item.name
                let lat = item.latitude
                let lng = item.longitude
                let ann = MapPin(coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: lng!), title: title!, pin: "wiw.png")
                mapView.addAnnotation(ann)
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MapPin) {
            return nil
        }
        
        let reuseId = "pinID"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! MapPin
        anView!.image = UIImage(named:cpa.pin!)
        
        return anView
    }
    //# MARK: - TileOverlay
    func addTileOverlay() {
        let baseURL = Bundle.main.bundleURL.absoluteString
        let urlTemplate = baseURL + "/July4thTiles/{z}/{x}/{y}.png/"
        let overlay = MKTileOverlay(urlTemplate:urlTemplate)
        overlay.isGeometryFlipped = true
        overlay.canReplaceMapContent = false
        self.mapView.add(overlay)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay:overlay)
            renderer.alpha = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
    //# MARK: - User Location
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    func startLocationUpdates() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if gpsDisplay == "Off" {
                gpsDisplay = "On"
                locationBtn.tintColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1)
                locateMeLabel.text = "Locate Me\nis on"
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = CLActivityType.fitness
                locationManager.distanceFilter = 10 // meters
                
                mapView.showsUserLocation = true
                mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
                UIApplication.shared.isIdleTimerDisabled = true
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
            } else if gpsDisplay == "On" {
                gpsDisplay = "Off"
                locationBtn.tintColor = UIColor.white
                locateMeLabel.text = "Locate Me\nis off"
                mapView.showsUserLocation = false
                mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
                UIApplication.shared.isIdleTimerDisabled = false
                stopLocationUpdates()
            }
            
        } else if status == .denied {
            openSettingGPS()
        }
    }
    func openSettingGPS() {
        let alertController = UIAlertController (title: "Location Service is off", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil);
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let eventDate: Date = newLocation.timestamp
            let howRecent: TimeInterval = eventDate.timeIntervalSinceNow
            if fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20 {
                let span = mapView.region.span
                let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
        }
        if gpsDisplay == "Off" {
            stopLocationUpdates()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if gpsDisplay == "On" {
            mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        } else if gpsDisplay == "Off" {
            stopLocationUpdates()
        }
    }
    //# MARK: - Web and Map View
    func createWebAndMapView() {
        
        mainMapView = UIView(frame: CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height))
        mainMapView.backgroundColor=UIColor(red: 32/255, green: 32/255, blue: 64/255, alpha: 1)
        mainView.addSubview(mainMapView)
        mapView = MKMapView(frame: CGRect(x: 0, y: 40, width: mainMapView.frame.width, height: mainMapView.frame.height-40))
        mapView.mapType = MKMapType.standard
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = false
        mainMapView.addSubview(mapView)
        
        addTileOverlay()
        
        locationBtn = UIButton(type: UIButtonType.system) as UIButton
        locationBtn.frame = CGRect(x: 12, y: 0, width: 32, height: 32)
        locationBtn.setImage(UIImage(named: "Location_Tab.png"), for:UIControlState())
        locationBtn.addTarget(self, action: #selector(ViewController.startLocationUpdates), for:.touchUpInside)
        locationBtn.tintColor = UIColor.white
        mainMapView.addSubview(locationBtn)
        
        locateMeLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 80, height: 40))
        locateMeLabel.text = "Locate Me\nis off"
        locateMeLabel.textColor=UIColor.white
        locateMeLabel.font = UIFont(name: "TrebuchetMS", size: 14)
        locateMeLabel.textAlignment = NSTextAlignment.left
        locateMeLabel.numberOfLines = 2
        mainMapView.addSubview(locateMeLabel)
        
        webView = UIWebView(frame: CGRect(x: mainView.frame.width, y: 0, width: mainView.frame.width, height: mainView.frame.height))
        webView.scalesPageToFit = true
        webView.delegate = self;
        mainView.addSubview(webView)
    }

    override func awakeFromNib() {
        
        for subview in animateView.subviews {
            subview.removeFromSuperview()
        }
        
        //Create the root layer
        animateView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        rootLayer = animateView.layer
        
        //Set the root layer's attributes
        rootLayer.bounds = CGRect(x: 0, y: -(animateView.frame.height/2), width: animateView.frame.width, height: animateView.frame.height)
        
        let colorSpace1: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let black1: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color1: CGColor = CGColor(colorSpace: colorSpace1, components: black1)!
        rootLayer.backgroundColor = color1
        //CGColorRelease(color)
        
        //Load the spark image for the particle
        //let fileName: char = [[[NSBundle mainBundle] pathForResource:"tspark" ofType:"png"] UTF8String]
        let fileName: String = Bundle.main.path(forResource: "tspark", ofType: "png")!
        let dataProvider: CGDataProvider = CGDataProvider(filename: fileName)!
        let img = CGImage(pngDataProviderSource: dataProvider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        
        
        mortor = CAEmitterLayer()
        mortor.emitterPosition = CGPoint(x: 160, y: -160)
        mortor.renderMode = kCAEmitterLayerAdditive
        
        //Invisible particle representing the rocket before the explosion
        let rocket: CAEmitterCell = CAEmitterCell()
        rocket.emissionLongitude = CGFloat(M_PI/2)
        rocket.emissionLatitude = 0
        rocket.lifetime = 1.6
        rocket.birthRate = 1
        rocket.velocity = 400
        rocket.velocityRange = 100
        rocket.yAcceleration = -250
        rocket.emissionRange = CGFloat(M_PI/4)
        
        let colorSpace2: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let black2: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color2: CGColor = CGColor(colorSpace: colorSpace2, components: black2)!
        rootLayer.backgroundColor = color2
        //CGColorRelease(color)
        
        rocket.redRange = 5
        rocket.greenRange = 5
        rocket.blueRange = 5
        
        //Name the cell so that it can be animated later using keypath
        rocket.name =  "rocket"
        
        //Flare particles emitted from the rocket as it flys
        let flare: CAEmitterCell = CAEmitterCell()
        flare.contents = img
        flare.emissionLongitude = CGFloat((4*M_PI)/2)
        flare.scale = 0.4
        flare.velocity = 100
        flare.birthRate = 45
        flare.lifetime = 1.5
        flare.yAcceleration = -350
        flare.emissionRange = CGFloat(M_PI/7)
        flare.alphaSpeed = -0.7
        flare.scaleSpeed = -0.1
        flare.scaleRange = 0.1
        flare.beginTime = 0.01
        flare.duration = 0.7
        
        //The particles that make up the explosion
        let firework: CAEmitterCell = CAEmitterCell()
        firework.contents = img
        firework.birthRate = 9999
        firework.scale = 0.6
        firework.velocity = 130
        firework.lifetime = 2
        firework.alphaSpeed = -0.2
        firework.yAcceleration = -80
        firework.beginTime = 1.5
        firework.duration = 0.1
        firework.emissionRange = CGFloat(2 * M_PI)
        firework.scaleSpeed = -0.1
        firework.spin = 2
        
        //Name the cell so that it can be animated later using keypath
        firework.name = "firework"
        
        //preSpark is an invisible particle used to later emit the spark
        let preSpark: CAEmitterCell = CAEmitterCell()
        preSpark.birthRate = 80
        preSpark.velocity = firework.velocity * 0.70
        preSpark.lifetime = 1.7
        preSpark.yAcceleration = firework.yAcceleration * 0.85
        preSpark.beginTime = firework.beginTime - 0.2
        preSpark.emissionRange = firework.emissionRange
        preSpark.greenSpeed = 50
        preSpark.blueSpeed = 50
        preSpark.redSpeed = 50
        
        //Name the cell so that it can be animated later using keypath
        preSpark.name = "preSpark"
        
        //The 'sparkle' at the end of a firework
        let spark: CAEmitterCell = CAEmitterCell()
        spark.contents = img
        spark.lifetime = 0.05
        spark.yAcceleration = -250
        spark.beginTime = 0.8
        spark.scale = 0.4
        spark.birthRate = 10
        
        preSpark.emitterCells = [spark]
        rocket.emitterCells = [flare, firework, preSpark]
        mortor.emitterCells = [rocket]
        
        rootLayer.addSublayer(mortor)
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

