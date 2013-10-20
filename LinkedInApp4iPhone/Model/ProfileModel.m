//
//  ProfileModel.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel

@synthesize mAdYear = _mAdYear;
@synthesize mBirthday = _mBirthday;
@synthesize mBirthplace = _mBirthplace;
@synthesize mCity = _mCity;
@synthesize mCompany = _mCompany;
@synthesize mDept = _mDept;
@synthesize mDesc = _mdesc;
@synthesize mDistrict = _mDistrict;
@synthesize mGender = _mGender;
@synthesize mGradYear = _mGradYear;
@synthesize mImgUrl = _mImgUrl;
@synthesize mMajor = _mMajor;
@synthesize mName = _mName;
@synthesize mNation = _mNation;
@synthesize mPosition = _mPosition;
@synthesize mProvince = _mProvince;
@synthesize mSchool = _mSchool;
@synthesize mStime = _mStime;
@synthesize mEtime = _mEtime;
@synthesize mOrg = _mOrg;


- (void)setMAdYear:(NSString *)mAdYear
{
    _mAdYear = [self checkNullWithString:mAdYear];
}

- (void)setMBirthday:(NSString *)mBirthday
{
    _mBirthday = [self checkNullWithString:mBirthday];
}

- (void)setMBirthplace:(NSString *)mBirthplace
{
    _mBirthplace = [self checkNullWithString:mBirthplace];
}

- (void)setMCity:(NSString *)mCity
{
    _mCity = [self checkNullWithString:mCity];
}

- (void)setMCompany:(NSString *)mCompany
{
    _mCompany = [self checkNullWithString:mCompany];
}

- (void)setMDept:(NSString *)mDept
{
    _mDept = [self checkNullWithString:mDept];
}

- (void)setMDesc:(NSString *)mDesc
{
    _mdesc = [self checkNullWithString:mDesc];
}

- (void)setMEtime:(NSString *)mEtime
{
    _mEtime = [self checkNullWithString:mEtime];
}

-(void)setMGender:(NSString *)mGender
{
    _mGender = [[self checkNullWithString:mGender] isEqualToString:@"1"] ? @"男":@"女";
}

-(void)setMGradYear:(NSString *)mGradYear
{
    _mGradYear = [self checkNullWithString:mGradYear];
}

-(void)setMImgUrl:(NSString *)mImgUrl
{
    _mImgUrl = [self checkNullWithString:mImgUrl];
}

-(void)setMMajor:(NSString *)mMajor
{
    _mMajor = [self checkNullWithString:mMajor];
}

-(void)setMName:(NSString *)mName
{
    _mName = [self checkNullWithString:mName];
}

-(void)setMNation:(NSString *)mNation
{
    _mNation = [self checkNullWithString:mNation];
}

-(void)setMPosition:(NSString *)mPosition
{
    _mPosition = [self checkNullWithString:mPosition];
}

-(void)setMProvince:(NSString *)mProvince
{
    _mProvince = [self checkNullWithString:mProvince];
}

-(void)setMSchool:(NSString *)mSchool
{
    _mSchool = [self checkNullWithString:mSchool];
}

-(void)setMStime:(NSString *)mStime
{
    _mStime = [self checkNullWithString:mStime];
}

- (void)setMOrg:(NSString *)mOrg
{
    _mOrg = [self checkNullWithString:mOrg];
}
- (void)setMPlace:(NSString *)mPlace
{
    _mPlace = [self checkNullWithString:mPlace];
}
- (void)setMSponsor:(NSString *)mSponsor
{
    _mSponsor = [self checkNullWithString:mSponsor];
}
- (void)setMType:(NSString *)mType
{
    _mType = [self checkNullWithString:mType];
}
- (void)setMMoney:(NSString *)mMoney{
    _mMoney = [self checkNullWithString:mMoney];
}
- (void)setMId:(NSString *)mId
{
    _mId = [self checkNullWithString:mId];
}
- (void)setMContent:(NSString *)mContent
{
    _mContent = [self checkNullWithString:mContent];
}
- (void)setMTitle:(NSString *)mTitle
{
    _mTitle = [self checkNullWithString:mTitle];
}
- (void)setMTel:(NSString *)mTel
{
    _mTel  = [self checkNullWithString:mTel];
}
- (NSString *)checkNullWithString:(NSString *)str
{
    if ([str isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%d",[str intValue]];
    }
    if (!str || [str isEqual:[NSNull null]]||str.length == 0 ) {
        return NODATA;
    }
    return str;
}

@end
