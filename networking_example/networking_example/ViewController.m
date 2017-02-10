#import "ViewController.h"
#import "GITHUBAPIController.h"
#import "RepositoryList2VC.h"
#import "UserInfoController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) UIView *grayView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showImage];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showImage];

    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.grayView];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    i.center = self.grayView.center;
    [i startAnimating];
    [self.grayView addSubview:i];
}

- (void)showImage
{
    NSString *userName = self.textField.text;
    userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller getAvatarForUser:userName
                     success:^(NSURL *imageURL) {
                         [wself.imageView setImageWithURL:imageURL];
                         [self.grayView removeFromSuperview];
                     }
                     failure:^(NSError *error) {
                         NSLog(@"Error: %@", error);
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unknown username" message:@"Try another username" preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                         }];
                         [alertController addAction:okButton];
                         [self presentViewController:alertController animated:YES completion:nil];
                         [self.grayView removeFromSuperview];
                     }];

    [self.controller getRepositoriesListForUser:userName
                                        success:^(NSDictionary *repos) {
                                            NSArray *repositoriesList = [UserInfoController getListOfRepositoriesForTable:repos];
                                            if ([repositoriesList count] > 0) {
                                                RepositoryList2VC *repositoryListVC = [[RepositoryList2VC alloc] init];
                                                repositoryListVC.callback = ^() {
                                                    [self dismissViewControllerAnimated:YES completion:NULL];
                                                };
                                                repositoryListVC.repositoriesList = repositoriesList;

                                                UINavigationController *navigationController =
                                                        [[UINavigationController alloc] initWithRootViewController:repositoryListVC];
                                                navigationController.title = [NSString stringWithFormat:@"%@'s repositories", userName];
                                                [self presentViewController:navigationController animated:YES completion:NULL];
                                            } else {
                                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No repository" message:@"This user didn't create repositories" preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                    [alertController dismissViewControllerAnimated:YES completion:nil];
                                                }];
                                                [alertController addAction:okButton];
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"Error: %@", error);
                                        }];
}

@end
