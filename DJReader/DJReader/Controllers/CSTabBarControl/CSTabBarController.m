//
//  CSTabBarController.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/26.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTabBarController.h"
#import "CSTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (CSTabBarControllerItemInternal)
- (void)cs_setTabBarController:(CSTabBarController*)tabBarController;
@end

@interface CSTabBarController ()
{
    UIView *_contentView;
}
@property (nonatomic, readwrite) CSTabBar *tabBar;

@end

@implementation CSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
    [self setTabBarHidden:NO animated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSelectedIndex:[self selectedIndex]];
}
//是否支持自动旋转
- (BOOL)shouldAutorotate{
    if (self.viewControllers.count > _selectedIndex) {
        //如果当前选中的控制器重写了是否支持自动旋转的方法，则返回选中控制器的返回值
        UIViewController *viewController = self.viewControllers[_selectedIndex];
        if ([viewController respondsToSelector:@selector(shouldAutorotate)]) {
            return [viewController shouldAutorotate];
        }
    }
    return YES;
}
//优先显示的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.viewControllers.count > _selectedIndex) {
        UIViewController *viewController = self.viewControllers[_selectedIndex];
        if ([viewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
            return [viewController preferredInterfaceOrientationForPresentation];
        }
    }
    return UIInterfaceOrientationPortrait;
}
//返回当前支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.viewControllers.count > _selectedIndex) {
        UIViewController *viewController = self.viewControllers[_selectedIndex];
        if ([viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return [viewController supportedInterfaceOrientations];
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Methods
- (UIViewController*)selectedViewController {
    return [self.viewControllers  objectAtIndex:self.selectedIndex];
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [self.tabBar setSelectedItem:self.tabBar.items[selectedIndex]];
    
    [self setSelectedViewController:[self.viewControllers objectAtIndex:selectedIndex]];
    [self.selectedViewController.view setFrame:[self contentView].bounds];
    [[self contentView] addSubview:self.selectedViewController.view];
    [self.selectedViewController didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        NSMutableArray *tabBarItems = [[NSMutableArray alloc]init];
        
        for (UIViewController *viewController in viewControllers) {
            CSTabBarItem *tabBarItem = [[CSTabBarItem alloc]init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController cs_setTabBarController:self];
        }
        [self.tabBar setItems:tabBarItems];
    }else{
        for (UIViewController *viewController in _viewControllers) {
            [viewController cs_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController*)viewController{
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers]indexOfObject:searchedController];
}

- (CSTabBar*)tabBar{
    if (!_tabBar) {
        _tabBar = [[CSTabBar alloc]init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView*)contentView {
    //自动布局自动调整宽高，左右底部边距
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return _contentView;
}
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    _tabBarHidden = hidden;
    __weak CSTabBarController *weakSelf = self;
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight(weakSelf.tabBar.frame);
        if (!tabBarHeight) {
            tabBarHeight = k_TabBar_Height;
        }
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (weakSelf.tabBar.isTransulcent) {
                contentViewHeight -= ([weakSelf.tabBar minimumContentHeight]?:tabBarHeight);
            }
            [weakSelf.tabBar setHidden:NO];
        }
        [weakSelf.tabBar setFrame:CGRectMake(0, tabBarStartingY, viewSize.width,tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    void(^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.1 animations:block completion:completion];
    }else{
        block();
        completion(YES);
    }
}
- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark -CSTabBarDelegate
- (BOOL)tabBar:(CSTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[index]]) {
            return NO;
        }
    }
    if (self.selectedViewController == self.viewControllers[index]) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)self.selectedViewController;
            
            if ([selectedController topViewController] != selectedController.viewControllers[0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        return NO;
    }
    return YES;
}
- (void)tabBar:(CSTabBar*)tabBar didSelectItemAtIndex:(NSInteger)index{
    if (index < 0 || index>= self.viewControllers.count) {
        return;
    }
    [self setSelectedIndex:index];
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[index]];
    }
}
@end

#pragma mark - UIViewController+CSTabBarControllerItem
@implementation UIViewController (RDVTabBarControllerItemInternal)
-(void)cs_setTabBarController:(CSTabBarController *)tabBarController{
    objc_setAssociatedObject(self, @selector(cs_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}
@end

@implementation UIViewController (CSTabBarControllerItem)
- (CSTabBarController *)cs_tabBarController {
    CSTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(cs_tabBarController));
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController cs_tabBarController];
    }
    return tabBarController;
}

- (CSTabBarItem *)cs_tabBarItem {
    CSTabBarController *tabBarController = [self cs_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [tabBarController.tabBar.items objectAtIndex:index];
}

- (void)cs_setTabBarItem:(CSTabBarItem *)tabBarItem {
    CSTabBarController *tabBarController = [self cs_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    CSTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:tabBar.items];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end
