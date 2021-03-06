#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"https://api.github.com";


@interface GITHUBAPIController ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end


@implementation GITHUBAPIController

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
    }

    return self;
}

+ (instancetype)sharedController
{
    static GITHUBAPIController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[GITHUBAPIController alloc] init];
    });

    return sharedController;
}

#pragma mark - Inner requests

- (void)getLink:(NSString *)userName
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString stringWithFormat:@"users/%@", userName];

    [self.sessionManager
        GET:requestString
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    
}

- (void)getInfoForUser:(NSString *)userName
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure
{
    [self getLink:userName success:success failure:failure];
}

- (void)getRepositoriesForUser:(NSString *)userName
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure
{
    NSString *link = [NSString stringWithFormat:@"%@/repos", userName];
    [self getLink:link success:success failure:failure];
}

#pragma mark - Public methods

- (void)getAvatarForUser:(NSString *)userName
    success:(void (^)(NSURL *))success
    failure:(void (^)(NSError *))failure
{
    [self getInfoForUser:userName
        success:^(NSDictionary *userInfo) {
            if(!!userInfo[@"avatar_url"]) {
                NSString *avatarURLString = userInfo[@"avatar_url"];
                NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
                success(avatarURL);
            } else {
                failure(nil);
            }
        }
        failure:^(NSError *error) {
            failure(error);
        }];
}

- (void)getRepositoriesListForUser:(NSString *)userName
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(NSError *))failure
{
    [self getRepositoriesForUser:userName
                 success:^(NSDictionary *repoArray) {
                     success(repoArray);
                 }
                 failure:^(NSError *error) {
                     failure(error);
                 }];
}

@end
