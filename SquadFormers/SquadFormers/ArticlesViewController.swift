// Assume this is running in the context of an actual user facing production appliction.

import UIKit

class ArticlesViewController: UIViewController, UITableViewDataSource {
  // - If we aren't intending to subclass ArticlesViewController for anything in the future, we might consider using final class here, final can speed up the build time considerably in Swift
  // - Additionally, if we are expecting this class to grow larger, we may (or may not) want to use an extension for UITAbleViewDataSource
    private var articles: [Article] = []
    private var tableView: UITableView = UITableView()
    //I don't know at present the overall strucutre of this app, but we amy consider doing the UI in UIKit with a xib as opposed to laying out UI programmatically
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        //same as above, do we want to do this programmatically or do we want to consider using a xib
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
      //this can likely be private, if we aren't calling fetchData from outside this class.
      
      //While this absolutely works and is fine at present, as self.articles strongly references back to us.. but because we don't strongly references this closure right now... it's generally fine.
      //However, if in the future we want to capture a class level variable here because we're going to reference numerous fetch calls (i.e. fetchComments, fetchLike etc) we might want to make this more robust for the future, just soa nother dev
      // in the future after having done that, doesn't accidentally leave this is a strong reference to self
      // so we may just want to reference this weakly now for the time being, and then ensure that you use a variable to strongly reference the weak reference inside the closure
      // i.e. [weal self] reuslt in.... guard let self = self else { return }
        APIClient.fetchArticles { [self] result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self.articles = articles
                    self.tableView.reloadData()
                    //How much data are we expecting in general for these articles? Is it small enough where we feel safe to just reload the entire tableView, or do we expect articles to grow
                    // to be large enough, where we might what to consider doing a diff on the article changeset (i.e. what was existing vs what is new), and then only reloading the new cells
                    // this is largely a greater team didcussion with product, backend, etc.
                    // If it is the latter where we are considering more data here, we likely are going to want to decide with the team the overall technical approach on reloading data. Diffs, changeset, reloads, etc.
                    // If we are pulling to refresh, and we happen to know that all of our data is on the "recent" side of things (i.e. we know all this data will be at the start or end of our dataSource, then we can just reload the affect portions of the dataSource.)
                }
            case .failure(let error):
                print(error)
                //I'm interested to know how this particular story is suggesting we deal with the errors. Are we doing that in a separate follow-up story or sub-task, or are we intending to do it in this PR. I didn't get a chance to look at the JIRA story.
                //If we are intending to deal with the error here, let's reference the JIRA story or if it hasn't been flushed out yet... we should probably have a discusion with Product/Design and either have them add the requirements to the story, or if they can spin up a secondary story/sub-task for error handling, then we can push that off to a separate PR
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
        //This Articles class at the moment is generally small enoguh, so this defintely works. Being new to the codebase, the first question that comes to my mind is... is there a general architectural pattern that we try to follow in this app. Are we using MVVM for example or another pattern. If so, we likely want to create a ArticlesDataViewModel and let's have that handle our [Articles], our fetch for the Data etc. This is a greater discussion so, we should probably get together as a team assuming this arch pattern hasn't already been flushed out in the app elsewhere.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell {
           cell.textLabel.text = articles[indexPath.row].title
        }
        
        //1. We might want to use a guard statement here to dequeue the cell. Good job with the resusable cell. We might do something like the following, what do you thinkg?
        // guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
        //    return UITableViewCell()
        // }
        // cell.textLabel.text = articles[indexPath.row].title
        
        // 2. Based on the discussion on line 50, if we go happen to go with the MVVM and DataViewModel approach here, then we'll get the data we need here from the dataViewModel.title
        
        // 3. A small nitpick here, but we may want to define the cell identifier here in a separate static variable a line above the current if statement, so `static let cellIdentifier = "ArticleCell"`
        
        return cell
    }
}

struct Article {
    let title: String
}

class APIClient {
    static func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let sampleArticles = [Article(title: "iOS Development"), Article(title: "SwiftUI Essentials")]
        completion(.success(sampleArticles))
    }
}
