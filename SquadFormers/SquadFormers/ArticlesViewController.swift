// Assume this is running in the context of an actual user facing production appliction.

import UIKit

final class ArticlesViewController: UIViewController, ArticlesViewModelProtocol {
    
    private var viewModel = ArticlesViewModel()
    private var tableView: UITableView = UITableView()
    //I don't know at present the overall strucutre of this app, but we amy consider doing the UI in UIKit with a xib as opposed to laying out UI programmatically
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        //same as above, do we want to do this programmatically or do we want to consider using a xib
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchData()
    }
    
    func dataDidUpdate() {
        tableView.reloadData()
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "ArticleCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        cell.textLabel.text = viewModel.articles[indexPath.row].title
        
        return cell
    }
}
