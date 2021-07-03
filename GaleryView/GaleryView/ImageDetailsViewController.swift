import UIKit

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet private weak var detailedImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var flickrImage: FlickrImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDetailedPicture()
    }
    
    private func loadDetailedPicture() {
        detailedImageView.image = flickrImage?.thumbnail
    }
}
