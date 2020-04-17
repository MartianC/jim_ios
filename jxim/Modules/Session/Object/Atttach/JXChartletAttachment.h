//
//  JXChartletAttachment.h
//  NIM
//
//  Created by chris on 15/7/10.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXCustomAttachmentDefines.h"

@interface JXChartletAttachment : NSObject<NIMCustomAttachment,JXCustomAttachmentInfo>

@property (nonatomic,copy) NSString *chartletId;

@property (nonatomic,copy) NSString *chartletCatalog;

@property (nonatomic,strong) UIImage *showCoverImage;

@end
