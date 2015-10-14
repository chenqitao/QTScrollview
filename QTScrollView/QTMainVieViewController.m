//
//  QTMainVieViewController.m
//  QTScrollView
//
//  Created by mac chen on 15/10/13.
//  Copyright © 2015年 陈齐涛. All rights reserved.
//

#import "QTMainVieViewController.h"
#import "QTScrollView.h"

@interface QTMainVieViewController ()

@end

@implementation QTMainVieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)creatUI {
    QTScrollView *scroll = [[QTScrollView alloc]initWithScrollViewFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100) AndImagesArray:@[@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg"] AndSize:CGSizeMake(50, 50) AndSeparatorOffset:100];
    scroll.tapImageBlock = ^(NSInteger selectIndex){
    
        NSLog(@"点击的位置%ld",(long)selectIndex);
    
    };
    [self.view addSubview:scroll];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
