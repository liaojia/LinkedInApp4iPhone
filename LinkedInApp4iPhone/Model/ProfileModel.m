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


- (void)setMOrg:(NSString *)mOrg
{
    _mOrg = [self checkNullWithString:mOrg];
}

- (NSString *)checkNullWithString:(NSString *)str
{
    if (!str || [str isEqualToString:@"<null>"] || str.length == 0) {
        return NODATA;
    }
    return str;
}

@end
