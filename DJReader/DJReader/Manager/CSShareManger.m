//
//  CSShareManger.m
//  CSShareDemo
//
//  Created by Andersen on 2020/4/17.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSShareManger.h"
#import "HWPop.h"
NSString *const CSActivityTypeCustomMine = @"CSActivityMine";

@implementation CSActivity
- (NSString *)activityType
{
    return CSActivityTypeCustomMine;
}
- (NSString *)activityTitle
{
    return @"点聚OFD";
}
- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"AppIcon"];
}
+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"activityItems = %@", activityItems);
    return YES;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"Activity prepare");
}
- (void)performActivity
{
    NSLog(@"Activity run");
}
- (void)activityDidFinish:(BOOL)completed
{
    NSLog(@"Activity finish");
}
@end

@interface CSShareManger()<UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong)HWPopController *popController;
@end

@implementation CSShareManger
+ (void)shareActivityController:(UIViewController*)controller withFile:(NSURL*)fileURL
{
    CSActivity *active = [[CSActivity alloc] init];
    NSString *shareTitle = @"点聚OFD";
    UIImage *shareImage = [UIImage imageNamed:@"AppIcon"];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[shareTitle,shareImage,fileURL] applicationActivities:@[active]];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [controller presentViewController:activity animated:YES completion:NULL];
}
+ (void)shareActivityController:(UIViewController *)controller withImages:(NSArray *)images
{
    CSActivity *active = [[CSActivity alloc] init];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:@[active]];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [controller presentViewController:activity animated:YES completion:NULL];
}
@end
