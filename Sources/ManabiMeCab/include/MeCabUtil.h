//
//  MeCabUtil.h
//
//  Created by Watanabe Toshinori on 10/12/22.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "mecab.h"

@interface MeCabUtil : NSObject {
    mecab_t *mecab;
}

+ (MeCabUtil *)sharedInstance;
- (NSArray *)parseToNodeWithString:(NSString *)string;

@end
