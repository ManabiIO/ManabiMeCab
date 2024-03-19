//
//  MeCabUtil.m
//
//  Created by Watanabe Toshinori on 10/12/22.
//  Copyright 2010 FLCL.jp. All rights reserved.
//
// MeCabUtil.m

#import "MeCabUtil.h"
#import "MeCabNode.h"

@implementation MeCabUtil

+ (MeCabUtil *)sharedInstance {
    static MeCabUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MeCabUtil alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize MeCab here
        NSString *path;
#ifdef SWIFTPM_MODULE_BUNDLE
        path = [SWIFTPM_MODULE_BUNDLE resourcePath];
#else
        path = [NSBundle bundleForClass:[self class]].resourcePath;
#endif
        path = [[@"-d " stringByAppendingString:path] stringByAppendingString:@""];
        mecab = mecab_new2(path.UTF8String);
        
        if (mecab == NULL) {
            path = [[NSBundle mainBundle] resourcePath];
            mecab = mecab_new2([[@"-d " stringByAppendingString:path] UTF8String]);
            
            if (mecab == NULL) {
                fprintf(stderr, "error in mecab_new2: %s\n", mecab_strerror(NULL));
            }
        }
    }
    return self;
}

- (void)dealloc {
    if (mecab != NULL) {
        mecab_destroy(mecab);
    }
}

- (NSArray *)parseToNodeWithString:(NSString *)string {
    if (mecab == NULL) {
        return nil; // Return early if MeCab is not initialized
    }
    
    const mecab_node_t *node;
    const char *buf = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger l = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    node = mecab_sparse_tonode2(mecab, buf, l);
    if (node == NULL) {
        fprintf(stderr, "error\n");
        return nil;
    }
    
    NSMutableArray *newNodes = [NSMutableArray array];
    node = node->next;
    for (; node->next != NULL; node = node->next) {
        MeCabNode *newNode = [MeCabNode new];
        newNode.surface = [[NSString alloc] initWithBytes:node->surface length:node->length encoding:NSUTF8StringEncoding];
        newNode.feature = [NSString stringWithCString:node->feature encoding:NSUTF8StringEncoding];
        if ([newNodes count] == 0) {
            newNode.spacesBefore = spacesWithLength(node->rlength - node->length);
        } else {
            newNode.spacesBefore = @"";
        }
        if (node->next != NULL) {
            newNode.spacesAfter = spacesWithLength(node->next->rlength - node->next->length);
        } else {
            newNode.spacesAfter = @"";
        }
        [newNodes addObject:newNode];
    }
    
    return [NSArray arrayWithArray:newNodes];
}

NSString *spacesWithLength(int nSpaces) {
    char UTF8Arr[nSpaces + 1];
    
    memset(UTF8Arr, ' ', nSpaces * sizeof(*UTF8Arr));
    UTF8Arr[nSpaces] = '\0';
    
    return [NSString stringWithUTF8String:UTF8Arr];
}

@end
