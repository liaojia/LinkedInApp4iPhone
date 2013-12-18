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

#define kOonePageCount 10

@interface BDViewController (){
}

@end

@implementation BDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"印象首师";
    self.delegate = self;
    
    testImgArray = @[@"http://img.my.csdn.net/uploads/201309/01/1378037235_3453.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037235_7476.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037235_9280.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037234_3539.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037234_6318.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037194_2965.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037193_1687.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037193_1286.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037192_8379.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037178_9374.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037177_1254.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037177_6203.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037152_6352.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037151_9565.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037151_7904.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037148_7104.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037129_8825.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037128_5291.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037128_3531.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037127_1085.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037095_7515.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037094_8001.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037093_7168.jpg",
                     @"http://img.my.csdn.net/uploads/201309/01/1378037091_4950.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949643_6410.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949642_6939.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949630_4505.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949630_4593.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949629_7309.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949629_8247.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949615_1986.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949614_8482.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949614_3743.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949614_4199.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949599_3416.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949599_5269.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949598_7858.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949598_9982.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949578_2770.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949578_8744.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949577_5210.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949577_1998.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949482_8813.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949481_6577.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949480_4490.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949455_6792.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949455_6345.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949442_4553.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949441_8987.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949441_5454.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949454_6367.jpg",
                     @"http://img.my.csdn.net/uploads/201308/31/1377949442_4562.jpg"];
    
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
        
            //TODO
             ImageShowView *imageShowView  = [[ImageShowView alloc]initWithFrame:CGRectMake(0, 0,320,480) url:testImgArray[viewIndex]];
            
            [self.view.superview.superview addSubview:imageShowView];
            
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.2;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.values = values;
            [imageShowView.layer addAnimation:animation forKey:nil];
    };

    
   [self animateReloadWithPage:1];
    

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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        [self.items addObject:imageView];
    }
    [self reloadData];
    
    for (int i=0; i<kOonePageCount; i++) {
        //NSDictionary *temDict = self.imgInfoArray[self.imgMtbArray.count+i];
        [self.imgMtbArray addObject:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:testImgArray[kOonePageCount*(page-1)+i ]]] success:^(UIImage *image) {
            
            
            [self.imgMtbArray replaceObjectAtIndex:kOonePageCount*(page-1)+i withObject:image];
            
            [self doUpdateWithIndex:kOonePageCount*(page-1)+i];
            
        }];
        
        [operation start];
    }
    
    currentPage++; //TODO
}
- (void)shouldUpDragUpdate
{
    [self animateReloadWithPage:currentPage+1];
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
