import UIKit

final class ImageCollectionViewController: UICollectionViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var clearSearchButton: UIBarButtonItem!
    
    private let reuseIdentifier = "ImageCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var searches: [FlickrSearchResults] = []
    private let flickr = Flickr()
    private let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    @IBAction func clearSearchButtonAction(_ sender: UIBarButtonItem) {
        print("🟢 Clear Search button did tapped!")
        clearSearchTextField()
    }
}

// MARK: - Private
private extension ImageCollectionViewController {
    func image(for indexPath: IndexPath) -> FlickrImage {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    func clearSearchTextField() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
    }
}

// MARK: - Search TextField Delegate
extension ImageCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty else { return true }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickr(for: text) { searchResults in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                
                switch searchResults {
                case .failure(let error) :
                    print("🔴 Error Searching: \(error)")
                case .success(let results):
                    print("""
              🟢 Found \(results.searchResults.count) \
              matching \(results.searchTerm)
              """)
                    self.searches.insert(results, at: 0)
                    self.collectionView?.reloadData()
                }
            }
        }
        clearSearchTextField()
        return true
    }
}

// MARK: - CollectionView DataSource
extension ImageCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrImageCell
        let flickrImage = image(for: indexPath)
        cell.backgroundColor = .white
        cell.imageView.image = flickrImage.thumbnail
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
