//
//  ImageShowView.m
//  HManager
//
//  Created by wenbin on 13-8-15.
//
//

#import "ImageShowView.h"

@implementation ImageShowView

/**
 *	@brief	唯一初始化函数
 *
 *	@param 	frame
 *	@param 	image 	要显示的图片
 *
 *	@return	
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image

{
     self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.7];
     
        
        [self initControlWithFrame:frame Image:image];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame url:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.7];
        
       _Block_H_ UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 200, 50, 50)];
        act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:act];
        [act startAnimating];
        
        //TODO 
        AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] success:^(UIImage *image) {
            
            [act removeFromSuperview];
            
            [self initControlWithFrame:frame Image:image];

        }];
        [operation start];
                                            
        
    }
    return self;
}

- (void)initControlWithFrame:(CGRect) frame Image:(UIImage*)image
{
    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((frame.size.width-10)/2, (frame.size.height-10)/2, 10, 10);
    imageView.image = image;
    [self addSubview:imageView];
    
    lastDistance=0;
    
    CGRect rect = CGRectMake(150, 150, 10, 10);
    
    //图片尺寸比view小 按原图尺寸显示
    if (image.size.width<frame.size.width&&image.size.height<frame.size.height)
    {
        rect = CGRectMake((frame.size.width-image.size.width)/2, (frame.size.height-image.size.height)/2,
                          image.size.width, image.size.height);
    }
    else
    {
        CGRect showRect = CGRectMake(0, 0, frame.size.width ,frame.size.height);
        float rate = image.size.width/image.size.height;
        
        float rateBox = showRect.size.width/(showRect.size.height);
        if(rate > rateBox){
            rect.size.width = frame.size.width;
            rect.size.height = frame.size.width/rate;
        }else{
            rect.size.height = showRect.size.height;
            rect.size.width = (showRect.size.height)*rate;
        }
        
        rect.origin.x= frame.size.width/2-rect.size.width/2;
        rect.origin.y = (showRect.size.height)/2-rect.size.height/2;
    }
    
    imageView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    imgStartWidth=imageView.frame.size.width;
    imgStartHeight=imageView.frame.size.height;
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(120, self.frame.size.height-35, 80, 30);
    [saveBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_n.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveToLocal) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    isMove = YES;
    
	CGPoint p1;
	CGPoint p2;
	CGFloat sub_x;
	CGFloat sub_y;
	CGFloat currentDistance;
	CGRect imgFrame;
	
	NSArray * touchesArr=[[event allTouches] allObjects];

	if ([touchesArr count]>=2)
    {
		p1=[[touchesArr objectAtIndex:0] locationInView:self];
		p2=[[touchesArr objectAtIndex:1] locationInView:self];
		
		sub_x=p1.x-p2.x;
		sub_y=p1.y-p2.y;
		
		currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
		
		if (lastDistance>0)
        {
			
			imgFrame=imageView.frame;
			
			if (currentDistance>lastDistance+2)
            {
                
				imgFrame.size.width+=20;
				if (imgFrame.size.width>10000)
                {
					imgFrame.size.width=10000;
				}
				
				lastDistance=currentDistance;
			}
			if (currentDistance<lastDistance-2)
            {
			
				imgFrame.size.width-=20;
				
				if (imgFrame.size.width<50)
                {
					imgFrame.size.width=50;
				}
				
				lastDistance=currentDistance;
			}
			
			if (lastDistance==currentDistance)
            {
				imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                
                float addwidth=imgFrame.size.width-imageView.frame.size.width;
                float addheight=imgFrame.size.height-imageView.frame.size.height;
                
				imageView.frame= CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
			}
			
		}
        else
        {
			lastDistance=currentDistance;
		}
        
	}
    else
    {
//        if (imageView.frame.size.width>self.frame.size.width&&
//            imageView.frame.size.height<=self.frame.size.height)
//        {
//            CGPoint currentpoint =[[touchesArr objectAtIndex:0] locationInView:imageView];
//            imageView.frame = CGRectMake(imageView.frame.origin.x+(currentpoint.x-touchpoint.x), imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
//        }
//        else if(imageView.frame.size.width<self.frame.size.width&&
//                imageView.frame.size.height>self.frame.size.height)
//        {
//            CGPoint currentpoint =[[touchesArr objectAtIndex:0] locationInView:imageView];
//            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+(currentpoint.y-touchpoint.y), imageView.frame.size.width, imageView.frame.size.height);
//        }
//        else if(imageView.frame.size.width>self.frame.size.width&&
//                imageView.frame.size.height>self.frame.size.height)
//        {
//            CGPoint currentpoint =[[touchesArr objectAtIndex:0] locationInView:imageView];
//            imageView.frame = CGRectMake(imageView.frame.origin.x+(currentpoint.x-touchpoint.x), imageView.frame.origin.y+(currentpoint.y-touchpoint.y), imageView.frame.size.width, imageView.frame.size.height);
//        }
       
        CGPoint currentpoint =[[touchesArr objectAtIndex:0] locationInView:imageView];
        imageView.frame = CGRectMake(imageView.frame.origin.x+(currentpoint.x-touchpoint.x), imageView.frame.origin.y+(currentpoint.y-touchpoint.y), imageView.frame.size.width, imageView.frame.size.height);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * touchesArr=[[event allTouches] allObjects];
    touchpoint=[[touchesArr objectAtIndex:0] locationInView:imageView];
    
    isMove = NO;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastDistance=0;
    
    NSArray * touchesArr=[[event allTouches] allObjects];
    if (touchesArr.count == 1) //单击时将页面移除
    {
        if (!isMove)
        {
            [UIView animateWithDuration: 0.5 animations:^{
                self.alpha = 0;
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                
            }];
            
        }
    }
}

- (void)saveToLocal
{
    UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil,nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                                    message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
