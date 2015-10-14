# QTScrollview
这是一个横向滚动的，可以使滚动到荧幕中间的图形变大，滚动效果也比较平滑，也有单击事件，用法比较简单，如下：
    QTScrollView *scroll = [[QTScrollView alloc]initWithScrollViewFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100) AndImagesArray:@[@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg",@"woniu.jpg"] AndSize:CGSizeMake(50, 50) AndSeparatorOffset:100];
    scroll.tapImageBlock = ^(NSInteger selectIndex){
    
        NSLog(@"点击的位置%ld",(long)selectIndex);
    
    };
    可以设置图形大小，样式以及它们之间的间隔，如果您希望和我继续优化和探讨的想法，可以加我QQ：326610240，我也会继续优化的。
    附上效果图：
     ![](https://github.com/chenqitao/QTScrollview/blob/master/QTScrollView/tab5.gif)
