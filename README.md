# NMFileManager

NMFileManager makes it easy for you to save file on disk (user's document directory) and retrieve it.

 
 ## Usage
 
 1. Add "NMFileManager.swift" to your project
 2. Create and delete folder to disk
 
 ```swift
 class ViewController: UIViewController { 
    override func viewDidLoad() {
        super.viewDidLoad()
        NMFileManager.createFolder("/images/")
        NMFileManager.deleteFolder("/images/")
    }
 }
 ```
 3. Save file to disk and retrieve it

```swift
class ViewController: UIViewController {
    var pdfUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        savePdfToDisk()
        downloadFrom("https://someURL/pdfWeb.pdf")
        
        pdfUrl = NMFileManager.getFile("pdfDisk.pdf")
    }

    func savePdfToDisk() {
        NMFileManager.saveFile("pdfDisk.pdf")
    }
    
    func downloadFrom(_ url: String) {
        let fileURL = URL(string: url)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
    
        session.downloadTask(with: fileURL) { (location, response, error) in    
            if let _ = error {
                print("Download fail: \(url). Error: \(error!.localizedDescription)")  
            } else {
                print("Download successful: ", fileURL)
                print("Finished downloading to \(location).")
                
                NMFileManager.saveFile(url, from: location)
            }
        
        }.resume()
    }    
}    

```

4. Save image to disk and retrieve it

```swift
class ViewController: UIViewController {
    var image1: UIImage?
    var image2: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NMFileManager.saveImage(image1, with: "image1.jpg")
        
        image2 = NMFileManager.getImage("image2.jpg")
    }
}
```

## License

[MIT License](https://github.com/nmacambira/NMFileManager/blob/master/LICENSE)

## Info

- Swift 4.1 

