
//
//  LDLeadView.m
//  BootstrapView
//
//  Created by 段乾磊 on 16/7/8.
//  Copyright © 2016年 LazyDuan. All rights reserved.
//

#import "LDLeadView.h"
//屏幕高度
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define WINDOW_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface LDLeadView()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@end
@implementation LDLeadView
//单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t singletonToken;
    static LDLeadView *leadView;
    dispatch_once(&singletonToken, ^{
        leadView = [[self alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    });
    return leadView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 3, WINDOW_HEIGHT * 7 / 8, WINDOW_WIDTH / 3, WINDOW_HEIGHT / 16)];
        // 设置页码的点的颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        // 设置当前页码的点颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
- (BOOL)checkLeadView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ![defaults boolForKey:@"notFirst"];
        
}
- (void)setImageArray:(NSArray *)array{
    self.scrollView.contentSize = CGSizeMake(WINDOW_WIDTH * array.count, WINDOW_HEIGHT);
    // 设置页数
    self.pageControl.numberOfPages = array.count;
    for(int i = 0;i<array.count;i++){
        UIImage *image = [UIImage imageNamed:array[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WINDOW_WIDTH * i, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        // 在最后一页创建按钮
        if (i == array.count-1) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(WINDOW_WIDTH / 3, WINDOW_HEIGHT * 6 / 8, WINDOW_WIDTH / 3, WINDOW_HEIGHT / 16);
            [button setTitle:@"点击进入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.backgroundColor = [UIColor orangeColor];
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [self.scrollView addSubview:imageView];
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算当前在第几页
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / WINDOW_WIDTH);
}
// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [userDefault setBool:YES forKey:@"notFirst"];
    [userDefault synchronize];
    //移除引导页
    [self removeFromSuperview];
}
@end
