//
//  CSTabBarController.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTabBarController.h"
#import "DJFileDocument.h"

NS_ASSUME_NONNULL_BEGIN

@interface  CSTabBarMainController: CSTabBarController<CSTarBarControllerDelegate,UISearchControllerDelegate>

@property (nonatomic,strong)NSURL *shareFileURL;
@property (nonatomic,strong)NSMutableArray * userFolders;
- (void)convertFile:(DJFileDocument*)file toFormat:(NSString*)format;
@end

NS_ASSUME_NONNULL_END
