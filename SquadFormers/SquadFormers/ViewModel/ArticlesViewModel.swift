import Foundation

protocol ArticlesViewModelProtocol: AnyObject {
    func dataDidUpdate()
}

class ArticlesViewModel {
    private (set) var articles: [Article] = []
    weak var delegate: ArticlesViewModelProtocol?
    
    func fetchData() {
        Task {
            do {
                let articles = try await ArticlesService().fetchArticles()
                self.articles = articles
                
                DispatchQueue.main.async {
                    self.delegate?.dataDidUpdate()
                    
                    //How much data are we expecting in general for these articles? Is it small enough where we feel safe to just reload the entire tableView, or do we expect articles to grow
                    // to be large enough, where we might what to consider doing a diff on the article changeset (i.e. what was existing vs what is new), and then only reloading the new cells
                    // this is largely a greater team didcussion with product, backend, etc.
                    // If it is the latter where we are considering more data here, we likely are going to want to decide with the team the overall technical approach on reloading data. Diffs, changeset, reloads, etc.
                    // If we are pulling to refresh, and we happen to know that all of our data is on the "recent" side of things (i.e. we know all this data will be at the start or end of our dataSource, then we can just reload the affect portions of the dataSource.)
                }
            } catch {
                print(error)
                
                //I'm interested to know how this particular story is suggesting we deal with the errors. Are we doing that in a separate follow-up story or sub-task, or are we intending to do it in this PR. I didn't get a chance to look at the JIRA story.
                //If we are intending to deal with the error here, let's reference the JIRA story or if it hasn't been flushed out yet... we should probably have a discusion with Product/Design and either have them add the requirements to the story, or if they can spin up a secondary story/sub-task for error handling, then we can push that off to a separate PR
            }
        }
    }
}
