//
//  ProfileModel.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject

@property(nonatomic, strong)    NSString *mName;
@property(nonatomic, strong)    NSString *mGender;// 性别
@property(nonatomic, strong)    NSString *mImgUrl;
@property(nonatomic, strong)    NSString *mCity;
@property(nonatomic, strong)    NSString *mProvince;
@property(nonatomic, strong)    NSString *mDistrict;
@property(nonatomic, strong)    NSString *mSchool;// 大学名称
@property(nonatomic, strong)    NSString *mDept;// 院系名称
@property(nonatomic, strong)    NSString *mMajor;// 专业名称
@property(nonatomic, strong)    NSString *mAdYear;// 入学年份
@property(nonatomic, strong)    NSString *mGradYear;// 毕业年份，如果尚未毕业则为null
@property(nonatomic, strong)    NSString *mCompany;
@property(nonatomic, strong)    NSString *mPosition;
@property(nonatomic, strong)    NSString *mStime;
@property(nonatomic, strong)    NSString *mEtime;
@property(nonatomic, strong)    NSString *mTitle; //身份
@property(nonatomic, strong)    NSString *mOrg;
@property(nonatomic, strong)    NSString *mId;
@property(nonatomic, strong)    NSString *mType;  //活动类型
@property(nonatomic, strong)    NSString *mMoney; //费用
@property(nonatomic, strong)    NSString *mPlace; //活动地点
@property(nonatomic, strong)    NSString *mSponsor; //活动主办方
@property(nonatomic, strong)    NSString *mContent;  //活动内容
@property(nonatomic, strong)    NSString *mIdCardNo; //身份证号
@property(nonatomic, strong)    NSString *mStuNo; //学号

/* 个人扩展信息 */
@property(nonatomic, strong)    NSString *mBirthday;// 生日，yyyy-mm-dd格式
@property(nonatomic, strong)    NSString *mBirthplace;// 籍贯
@property(nonatomic, strong)    NSString *mNation;// 民族
@property(nonatomic, strong)    NSString *mDesc;// 个人描述
@property(nonatomic, strong)    NSString *mTel;  //联系方式

- (NSString *)checkNullWithString:(NSString *)str;

@end
