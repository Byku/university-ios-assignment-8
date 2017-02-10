#import <Foundation/Foundation.h>

@interface RepositoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *repositoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCommitDateLabel;

@end
