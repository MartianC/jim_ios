//
//  RequestSearchAccount.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestSearchAccount.h"
#import "JXUserDataManager.h"

@interface RequestSearchAccount()

@property(nonatomic,copy) NSString *searchContent;

@end

@implementation RequestSearchAccount


-(instancetype)initWithSearchContent:(NSString *)searchContent
{
    if (self = [super init]) {
        _searchContent = searchContent;
    }
    return self;
}

-(JIMAccountSimple *)account
{
    NSDictionary *data = self.respData;
    if (!data || data.count < 1) return nil;
    
    return [JIMAccountSimple unarchiveObjectWithDictionary:data];
}

-(NSString *)requestUrl
{
    return RequestUrl_SearchAccount;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId":JXUserDataManager.sharedInstance.userData.jim_uniqueid,
        @"searchContent":_searchContent
    };
}

@end
