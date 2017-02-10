#import "RepositoryList2VC.h"
#import "RepositoryCell.h"

@interface RepositoryList2VC ()
<UITableViewDataSource,
UITableViewDelegate>

@end

@implementation RepositoryList2VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.repositoriesList[0][@"ownerName"]];
    UIBarButtonItem *const backBarButtonItem =
            [[UIBarButtonItem alloc]
                    initWithTitle:@"Back"
                            style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(didTouchBackBarButtonItem)];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repositoriesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repositoryCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"RepositoryCell" bundle:nil] forCellReuseIdentifier:@"repositoryCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"repositoryCell"];
    }

    cell.lastCommitDateLabel.text = [self.repositoriesList[indexPath.row][@"lastCommitDate"] substringToIndex:10];
    cell.repositoryNameLabel.text = self.repositoriesList[indexPath.row][@"repositoryName"];


    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - auxiliary functions

- (void)didTouchBackBarButtonItem
{
    if(!!self.callback){
        self.callback();
    }
}
@end
