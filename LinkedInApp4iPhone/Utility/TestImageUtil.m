//
//  TestImageUtil.m
//  LinkedInApp4iPhone
//
//  Created by  STH on 12/22/13.
//  Copyright (c) 2013 liao jia. All rights reserved.
//

#import "TestImageUtil.h"

@implementation TestImageUtil

+ (NSArray *) getAllImages
{
    return [NSArray arrayWithObjects:
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15815&filename=20131209144643404.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15820&filename=20131209145251129.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15823&filename=20131210130505295.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15362&filename=20131031155715804.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15368&filename=20131101090654481.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15257&filename=20131021165222134.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15931&filename=20131218152455168.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15932&filename=20131218152510408.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15940&filename=20131218163533784.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15941&filename=20131218163540947.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15900&filename=20131216165616647.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15934&filename=20131218152727707.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15936&filename=20131218152750372.jpg",
            @"http://www.cnu.edu.cn/download.jsp?attachSeq=15961&filename=20131219160922700.jpg",
            nil];
}

+ (int) getRandom
{
    int random = arc4random() % [[TestImageUtil getAllImages] count];
    
    return random;
}

+ (NSString *) getAImage
{
    return [[TestImageUtil getAllImages] objectAtIndex:[TestImageUtil getRandom]];
}

+ (NSArray *) getImageList
{
    NSDictionary *dic1 = [NSDictionary dictionaryWithObject:[[TestImageUtil getAllImages] objectAtIndex:[TestImageUtil getRandom]] forKey:@"url"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObject:[[TestImageUtil getAllImages] objectAtIndex:[TestImageUtil getRandom]] forKey:@"url"];
    
    return [NSArray arrayWithObjects:dic1, dic2, nil];
}


@end
