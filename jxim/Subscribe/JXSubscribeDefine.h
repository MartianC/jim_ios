//
//  JXSubscribeDefine.h
//  NIM
//
//  Created by chris on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef JXSubscribeDefine_h
#define JXSubscribeDefine_h

extern NSString *const JXSubscribeNetState;
extern NSString *const JXSubscribeOnlineState;

typedef NS_ENUM(NSInteger, JXCustomStateValue) {
    JXCustomStateValueOnlineExt = 10001,
};

typedef NS_ENUM(NSInteger, JXOnlineState){
    JXOnlineStateNormal, //在线
    JXOnlineStateBusy,   //忙碌
    JXOnlineStateLeave,  //离开
};


#endif /* JXSubscribeDefine_h */
