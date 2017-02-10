#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
                 success:(void(^)(NSURL *))success
                 failure:(void(^)(NSError *))failure;

- (void)getRepositoriesListForUser:(NSString *)userName
                           success:(void (^)(NSDictionary *))success
                           failure:(void(^)(NSError *))failure;
@end
