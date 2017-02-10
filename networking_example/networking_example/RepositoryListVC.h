#import <UIKit/UIKit.h>

typedef void(^RepositoryListVCCallback)(void);

@interface RepositoryListVC : UIViewController

@property (nonatomic, copy) RepositoryListVCCallback callback;
@property (nonatomic) NSArray *repositoriesList;

@end
