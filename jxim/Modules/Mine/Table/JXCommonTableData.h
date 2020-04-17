//
//  JXTableData.h
//  jxim
//
//  Created by Xueyue Liu on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMCommonTableData.h"


NS_ASSUME_NONNULL_BEGIN

@interface JXCommonTableSection : NIMCommonTableSection

@end


@interface JXCommonTableRow : NIMCommonTableRow

@property (nonatomic,strong) NSString *icon;
@property (nonatomic,assign) BOOL showRedDot;
@property (nonatomic,assign) BOOL showBottomLine;
@property (nonatomic,assign) NSInteger accessoryType;

@end


NS_ASSUME_NONNULL_END
