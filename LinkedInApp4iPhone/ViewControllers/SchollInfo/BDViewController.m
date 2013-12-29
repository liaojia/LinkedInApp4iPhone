//
//  BDViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController.h"
#import "BDRowInfo.h"
#import "ImageShowView.h"
#import <QuartzCore/QuartzCore.h>

#define kOonePageCount 3

@interface BDViewController (){
}

@end

@implementation BDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"印象首师";
    self.delegate = self;
    
     
    self.imgMtbArray = [NSMutableArray arrayWithCapacity:0];
    self.items = [NSMutableArray arrayWithCapacity:0];
    self.imgInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Long press on %@, at %d", view, viewIndex);
    };

    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Double tap on %@, at %d", view, viewIndex);
    };
    
    self.onSingleTap =  ^(UIView* view, NSInteger viewIndex){
        
        NSDictionary *temDict = self.imgInfoArray[viewIndex];
             ImageShowView * imageShowView  = [[ImageShowView alloc]initWithFrame:self.view.frame url:temDict[@"pic"]];
            
            [self.view.superview.superview addSubview:imageShowView];
            
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.2;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.values = values;
            [imageShowView.layer addAnimation:animation forKey:nil];
    };

    
    currentPage=0;
    [self getImgInfoWithPage:1];

}

/**
 *  获取照片列表
 *
 *  @param page
 */
- (void)getImgInfoWithPage:(int)page
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":[NSString stringWithFormat:@"%d",kOonePageCount]} requesId:@"GETPHOTOLIST" messId:nil success:^(id obj)
                                         {
                                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                                 {
                                    
                                     NSArray *listArray = obj[@"list"];
                                     listTotalCount = [obj[@"total"] intValue];
                                     
                                     [self.imgInfoArray addObjectsFromArray:listArray];
                                     
                                     [self animateReloadWithPage:currentPage+1];
                                      currentPage++;
                                
                                 }
                                 else if([[obj objectForKey:@"rc"]intValue] == -1)
                                 {
                                     [SVProgressHUD showErrorWithStatus:@"图片数据加载失败！"];
                                 }
                                 else
                                 {
                                     [SVProgressHUD showErrorWithStatus:@"照片加载失败！"];
                                 }
                                 
                                 
                             } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];

}
/**
 *  刷新
 *
 *  @param page
 */
- (void)animateReloadWithPage:(int)page
{
    for (int i=0; i < kOonePageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        [self.items addObject:imageView];
    }
    [self reloadData];
    
    for (int i=0; i<kOonePageCount; i++) {
        NSDictionary *temDict = self.imgInfoArray[kOonePageCount*(page-1)+i ];
        [self.imgMtbArray addObject:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temDict[@"thumbnail"]]] success:^(UIImage *image) {
            
            
            [self.imgMtbArray replaceObjectAtIndex:kOonePageCount*(page-1)+i withObject:image];
            
            [self doUpdateWithIndex:kOonePageCount*(page-1)+i];
            
        }]; 
        
        [operation start];
    }
    
}
- (void)shouldUpDragUpdate
{
    if (self.imgInfoArray.count>=listTotalCount)
    {
        [SVProgressHUD showErrorWithStatus:@"无更多数据！"];
    }
    else
    {
       [self animateReloadWithPage:currentPage+1];
    }
    
}
- (NSUInteger)numberOfViews
{
    return self.items.count;
}

-(NSUInteger)maximumViewsPerCell
{
    return 5;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
    UIImageView * imageView = [self.items objectAtIndex:index];
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}


- (void)doUpdateWithIndex:(int)index
{
    UIImageView *imageView = [self.items objectAtIndex:index];
    UIImage *image = [self.imgMtbArray objectAtIndex:index];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [self performSelector:@selector(animateUpdate:)
               withObject:[NSArray arrayWithObjects:imageView, image, nil]
               afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];

}

- (void) animateUpdate:(NSArray*)objects
{
    UIImageView *imageView = [objects objectAtIndex:0];
    UIImage* image = [objects objectAtIndex:1];
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imageView.image = image;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              imageView.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}
- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
//    if (rowInfo.viewsPerCell == 1) {
//        return 125  + (arc4random() % 55);
//    }else {
//        return 100;
//    }
    return 55 + (arc4random() % 125);
}

@end
