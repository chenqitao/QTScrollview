//
//  QTScrollView.m
//  QTScrollView
//
//  Created by mac chen on 15/10/13.
//  Copyright © 2015年 陈齐涛. All rights reserved.
//

#import "QTScrollView.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow
@implementation QTScrollView
{
    NSArray        *imagesUrlArray;  /**< 用于接收定义的图片数组*/
    CGSize         imgSize;          /**< 每一个图片的大小尺寸*/
    NSMutableArray *imageArr;        /**< 存放图片的数组*/
    CGFloat        separatorOffset;  /**< 设置图片间隔*/
    NSInteger      selectIndex;      /**< 记录滚动选中的图片位置*/
}

- (instancetype)initWithScrollViewFrame:(CGRect)frame  AndImagesArray:(NSArray *)imageArray  AndSize:(CGSize)imageSize AndSeparatorOffset:(CGFloat)sepOffset
{
    imageArr = [NSMutableArray array];
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        imagesUrlArray = imageArray;
        imgSize = imageSize;
        separatorOffset = sepOffset;
        self.backgroundColor = [UIColor redColor];
        //创建scroll的内容大小
        self.contentSize = CGSizeMake((imageSize.width+separatorOffset)*imagesUrlArray.count+1, imageSize.height);
        //添加每一个小图片
        for (int index = 0;index < imagesUrlArray.count ; index++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((index+1)*(imageSize.width+separatorOffset), self.frame.origin.y-30, imageSize.width, imageSize.height)];
            imageView.image = [UIImage imageNamed:imagesUrlArray[index]];
            imageView.layer.cornerRadius = imageSize.width/2;
            imageView.layer.masksToBounds = YES;
            [imageArr addObject:imageView];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollAnimationWithOffset:scrollView.contentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollAnimationWithOffset:scrollView.contentOffset];
}

#pragma mark --停止滑动调用方法
- (void)scrollAnimationWithOffset:(CGPoint)offset {
    
    CGFloat biggestSize = 0; //最大的一个image的此尺寸
    UIImageView *biggestView; //最大的一个image
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *image = imageArr[i];
        //保证图片的位置在屏幕内
        if (image.center.x > offset.x && image.center.x < (offset.x + KeyWindow.frame.size.width))
        {
            //获取最大的一个图片
            if (((image.center.x + image.frame.size.width) - image.center.x) > biggestSize)
            {
                biggestSize = ((image.frame.origin.x + image.frame.size.width) - image.frame.origin.x);
                biggestView = image;
                for (UIImageView *imageview in self.subviews) {
                    if ([imageview isEqual:image]) {
                        imageview.userInteractionEnabled = YES;
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
                        [imageview addGestureRecognizer:tap];
                        selectIndex = i;
                    }
                    else {
                        imageview.userInteractionEnabled = NO;
                    }
                }
            }
        }
    }
    
    //现在开始做scrollview的偏移，确保图片在最中央
    
    //取滑动时图片不在正中间，此时取左右的偏移量
    float biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width/2 - self.frame.size.width/2;
    float littleX = self.contentOffset.x - biggestViewX;
    float finalX = self.contentOffset.x - littleX/1.4;
    
    // Disable scrolling when snapping to new location
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^ {
        [self setScrollEnabled:NO];
        //滚动一个特定区域的内容以便它在接收是可见的
        [self scrollRectToVisible:CGRectMake(finalX, 0, self.frame.size.width, 1) animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [self setScrollEnabled:YES];
        });
    });
}


- (void)layoutSubviews {
    
    [self reloadView:self.contentOffset.x];
}

#pragma mark --当滑动scrollView的时候，会调用如下方法
- (void)reloadView:(CGFloat)offset {
    CGFloat         biggestSize = 0;  //定义最大一个图片的尺寸
    UIImageView    *biggestView;      //定义最大的一个图片
    
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *image = imageArr[i];
        //确保图片在屏幕内
        if (image.center.x > (offset - imgSize.width ) && image.center.x < (offset + self.frame.size.width + imgSize.width))
        {
            
            //这里问题来了，怎么才能实时得到放大缩小的值呢,当滑动scrollview的时候此方法就会调用，此时，在同一个contentoffset的时候屏幕中的图片中心相对于contentoffset是不同的，我们可以通过这个值来改变图片的大小
            //缩小范围
            CGFloat lrOffset = (image.center.x - offset) - self.frame.size.width/4;
            //判断如果超出了屏幕则回收
            if (lrOffset < 0 || lrOffset > self.frame.size.width)
            {
                lrOffset = 0;
            }
            //这里计算相当复杂,和屏幕中心轴进行偏差对比然后进行放大，和之前做下拉放大tableview的顶部图片以及改变alpha一样的原理
            CGFloat addHeight = (-1 * fabs((lrOffset)*2 - self.frame.size.width/2) + self.frame.size.width/2)/4;
            
            addHeight = addHeight<0?0:addHeight;
            image.frame = CGRectMake(image.frame.origin.x,
                                     self.frame.size.height - imgSize.height  - (addHeight),
                                     imgSize.width + addHeight,
                                     imgSize.height + addHeight);
            image.layer.cornerRadius = (imgSize.width+addHeight)/2;
            image.layer.masksToBounds = YES;
            
            //取最大的一个的尺寸
            if (((image.frame.origin.x + image.frame.size.width) - image.frame.origin.x) > biggestSize)
            {
                biggestSize = ((image.frame.origin.x + image.frame.size.width) - image.frame.origin.x);
                biggestView = image;
            }
            
        } else {
            //没有在中间，还原
            image.frame = CGRectMake(image.frame.origin.x, self.frame.origin.y, imgSize.width, imgSize.height);
        }
    }
    
    for (int i = 0; i < imageArr.count; i++)
    {
        UIView *currentImage = [imageArr objectAtIndex:i];
        if (i > 0)
        {
            UIView *lastImage = [imageArr objectAtIndex:i-1];
            currentImage.frame = CGRectMake(lastImage.frame.origin.x + lastImage.frame.size.width+separatorOffset/2, currentImage.frame.origin.y, currentImage.frame.size.width, currentImage.frame.size.height);
        }
    }
}

#pragma mark --点击回调事件
- (void)tapImageView:(UIGestureRecognizer *)gesture {
    if (_tapImageBlock) {
        _tapImageBlock(selectIndex);
    }
}




@end
