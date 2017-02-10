#import "UserInfoController.h"

@implementation UserInfoController {

}

+ (NSArray *)getListOfRepositoriesForTable:(NSDictionary *)repoDictionary
{
    NSMutableArray *arr = [NSMutableArray new];
    for(NSDictionary *repository in repoDictionary){
        NSMutableDictionary *obj = [NSMutableDictionary new];
        obj[@"ownerName"] = repository[@"owner"][@"login"];
        obj[@"repositoryName"] = repository[@"name"];
        obj[@"lastCommitDate"] = repository[@"pushed_at"];

        [arr addObject:obj];
    }
    return [arr copy];
}
@end
