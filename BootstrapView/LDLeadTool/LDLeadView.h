//
//  LDLeadView.h
//  BootstrapView
//
//  Created by 段乾磊 on 16/7/8.
//  Copyright © 2016年 LazyDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDLeadView : UIView
+ (instancetype)sharedInstance;
//判断是否首次进入app
- (BOOL)checkLeadView;
- (void)setImageArray:(NSArray *)array;
@end
