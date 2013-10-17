//
//  StaticFormatTools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import "StaticTools.h"


@interface StaticTools(StaticFormatTools)

/*
 @abstract 格式化电话号码
 */
+ (NSString *)formatPhoneNo:(NSString *)phoneNo;
+(NSDate *)convertDateToLocalTime:(NSDate *)forDate;
//从指定日期字符串的初始化一个NSdate
+ (NSDate*)getDateFromDateStr:(NSString*)dateStr;
//获取指定日期的字符串表达式 需要当前日期时传入：[NSDate date] 即可 注意时区转换
+ (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime;
//判断一个字符串是否为整型数字
+ (BOOL) isPUreInt:(NSString*)string;
//判断一个字符串是否为浮点型数字
+ (BOOL) isPUreFloat:(NSString*)string;
//判断邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString*)email;
@end

