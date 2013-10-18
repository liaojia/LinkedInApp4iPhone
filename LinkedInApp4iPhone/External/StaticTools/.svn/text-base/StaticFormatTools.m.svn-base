//
//  StaticFormatTools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticFormatTools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticFormatTools.h"

@implementation StaticTools(StaticFormatTools)

/*
 @abstract 格式化电话号码
 */
+ (NSString *)formatPhoneNo:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

//转换时区 输入时间 输出＋8时间
+(NSDate *)convertDateToLocalTime:(NSDate *)forDate
{
    
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    
    int timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    
    
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    
    return newDate;
    
}
/**
 *	@brief	从指定日期字符串的初始化一个NSdate
 *
 *	@param 	dateStr 指定日期的字符串 注意分割线 支持 2012-12-12 和 2012/12/12 两种形式分隔
 *       可以带时间 如2012-12-12 10:12:12 若未带时间 则返回的date的时间为默认的08:00:00(系统默认时间为00:00:00 调用convertDateToLocalTime后变成 08:00:00)
 *	@return
 */
+ (NSDate*)getDateFromDateStr:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([dateStr rangeOfString:@"-"].location!=NSNotFound) {
        if (dateStr.length>10) {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }
    }
    else
    {
        if (dateStr.length>10) {
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"yyyy/MM/dd"];
        }
    }
	NSDate *date = [formatter  dateFromString:dateStr];
    [formatter release];
    date = [StaticTools convertDateToLocalTime:date];
    return date;
}


/**
 *	@brief	获取指定日期的字符串表达式 需要当前日期时传入：[NSDate date] 即可 注意时区转换
 *
 *	@param 	someDate 	指定的日期 NSDate类型
 *	@param 	typeStr 	分割线类型 @"/" 或者@“-”  传nil时默认使用@“-”
 *  @param  hasTime     是否需要返回时间
 *	@return	返回的日期字符串  格式为 2012-13-23 或者 2013/13/23 或2012-12-12 12:11:11 或2102/12/12 12:12:12
 */
+ (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime
{
    if (cutStr == nil) {
        cutStr = @"-";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *str = nil;
    if (hasTime) {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss",cutStr,cutStr];
    }
    else
    {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd",cutStr,cutStr];
    }
	[formatter setDateFormat:str];
	NSString *date = [formatter stringFromDate:someDate];
	[formatter release];
	return date;
}

/**
 *	@brief	判断一个字符串是否为整型数字
 *
 *	@param 	string
 *
 *	@return	
 */
+ (BOOL) isPUreInt:(NSString*)string

{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}

/**
 *	@brief	判断一个字符串是否为浮点型数字
 *
 *	@param 	string 	
 *
 *	@return	
 */
+ (BOOL) isPUreFloat:(NSString*)string

{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val]&&[scan isAtEnd];
}

/**
 *	@brief	判断邮箱格式是否正确
 *
 *	@param 	email
 *
 *	@return	
 */
+ (BOOL)isValidateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
