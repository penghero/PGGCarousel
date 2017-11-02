//
//  ViewController.m
//  PGGCarousel
//
//  Created by 陈鹏 on 2017/10/31.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//GitHub 地址 https://github.com/penghero/PGGCarousel.git

#import "ViewController.h"
#import "PGGCarouselView.h"
#import "PGGCarouselTextView.h"
#define PGG_Weight self.view.bounds.size.width
@interface ViewController ()<PGGCarouselDelegate,PGGCarouselTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    NSArray *images = @[[UIImage imageNamed:@"001.jpg"],
                                        [UIImage imageNamed:@"002.jpg"],
                                        [UIImage imageNamed:@"003.jpg"],
                                        [UIImage imageNamed:@"004.jpg"],
                                        [UIImage imageNamed:@"005.jpg"],
                                        [UIImage imageNamed:@"006.jpg"]
                                    ];
    
    NSArray *titles = @[@"感谢您的支持",
                        @"关注鹏哥哥GitHub",
                        @"没毛病， 老铁",
                        @"有事儿您说话"
                        ];
    NSArray *topTitleArr = @[@"敌军还有五秒到达战场！！！",
                                 @"请做好准备！！！",
                                 @"全军出击！！！",
                                 @"全体进攻中路",@"Victory"];
    NSArray *signImageArr = @[@"hot",
                              @"activity",
                              @"activity",
                              @"hot",
                              @"activity"];
    NSArray *bottomTitleArr = @[@"猥琐发育，别浪！",
                                @"我拿BUFF，谢谢",
                                @"请求集合，开始撤退",
                                @"进攻暴君",
                                @"The Failed"];
    
    NSArray *signImageArray = @[@"horn_icon",
                              @"horn_icon",
                              @"horn_icon",
                              @"horn_icon"];

// 创建不带标语的轮播
    PGGCarouselView *pggView = [PGGCarouselView PGGCarouseScrollViewWithFrame:CGRectMake(0, 64, PGG_Weight, 200) imgsData:images];
    
//创建带标语的轮播
//    PGGCarouselView *pggView = [PGGCarouselView PGGCarouseScrollViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200) imgsData:images titlesData:titles];
    pggView.TimerInterval = 4;
    pggView.delegate = self;
    [self.view addSubview:pggView];
    
    
    /**创建文字轮播   设置各个属性 根据项目需要自行添加*/
    PGGCarouselTextView *pggText = [[PGGCarouselTextView alloc] initWithFrame:CGRectMake(0, 330, PGG_Weight, 30)];
    pggText.titles = titles;
    pggText.backgroundColor = [UIColor clearColor];
    pggText.titleColor = [UIColor whiteColor];
    pggText.textAlignment = NSTextAlignmentCenter;
    pggText.delegate = self;
    pggText.signImages = signImageArray;
    pggText.titleFont = [UIFont systemFontOfSize:24];
    [self.view addSubview:pggText];
    
    
    PGGCarouselTextView *pggNext = [[PGGCarouselTextView alloc] initWithFrame:CGRectMake(0, 400, PGG_Weight, 50)];
    pggNext.ScrollViewStyle = PGGScrollViewStyleDouble;
    pggNext.scrollTimeInterval = 3;
    pggNext.topTitles = topTitleArr;
    pggNext.topTitleColor = [UIColor whiteColor];
    pggNext.bottomSignImages = signImageArr;
    pggNext.bottomTitles = bottomTitleArr;
    pggNext.titleFont = [UIFont systemFontOfSize:20];
    pggNext.bottomTitleColor = [UIColor redColor];
    pggNext.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pggNext];
}
//PGGCarouselDelegate
- (void)PGGCarouseScrollView:(PGGCarouselView *)CarouseView didSelectAtIndex:(NSInteger )index{
    NSLog(@"%ld",(long)index);
}
//PGGCarouselTextViewDelegate
- (void)pggScrollView:(PGGCarouselTextView *)ScrollView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
