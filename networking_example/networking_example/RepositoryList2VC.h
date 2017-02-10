#import <UIKit/UIKit.h>

typedef void(^RepositoryListVCCallback)(void);

@interface RepositoryList2VC : UIViewController

@property (nonatomic, copy) RepositoryListVCCallback callback;
@property (nonatomic) NSArray *repositoriesList;

@end
