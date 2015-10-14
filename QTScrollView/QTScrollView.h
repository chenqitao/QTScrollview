//
//  QTScrollView.h
//  QTScrollView
//
//  Created by mac chen on 15/10/13.
//  Copyright © 2015年 陈齐涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapImageViewblock)(NSInteger selectIndex); /**< 定义回调传值事件*/

@interface QTScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, copy) TapImageViewblock tapImageBlock;

- (instancetype)initWithScrollViewFrame:(CGRect)frame  AndImagesArray:(NSArray *)imageArray  AndSize:( CGSize)imageSize AndSeparatorOffset:(CGFloat)sepOffset;

@end
