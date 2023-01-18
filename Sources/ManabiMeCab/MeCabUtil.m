//
//  MeCabUtil.m
//
//  Created by Watanabe Toshinori on 10/12/22.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iconv.h>
#import "MeCabUtil.h"
#import "MeCabNode.h"
#import <Foundation/Foundation.h>
#import "mecab.h"

NSString *spacesWithLength(int nSpaces)
{
    char UTF8Arr[nSpaces + 1];

    memset(UTF8Arr, ' ', nSpaces * sizeof(*UTF8Arr));
    UTF8Arr[nSpaces] = '\0';

    return [NSString stringWithUTF8String:UTF8Arr];
}

@implementation MeCabUtil

- (NSArray *)parseToNodeWithString:(NSString *)string {

	if (mecab == NULL) {
		
#if TARGET_IPHONE_SIMULATOR
		// Homebrew mecab path
        //NSString *path = @"/usr/local/Cellar/mecab-ipadic/2.7.0-20070801/lib/mecab/dic/ipadic/";
		//NSString *path = @"/usr/local/Cellar/mecab/0.996/lib/mecab/dic/ipadic";
//		NSString *path = @"/usr/local/mecab/lib/mecab/dic/ipadic/";
        NSString *path = NSBundle.mainBundle.resourcePath;
#else
		NSString *path = NSBundle.mainBundle.resourcePath;
#endif
        path = [@"-d " stringByAppendingString:path];
		mecab = mecab_new2(path.UTF8String);

		if (mecab == NULL) {
			fprintf(stderr, "error in mecab_new2: %s\n", mecab_strerror(NULL));
			
			return nil;
		}
	}

	const mecab_node_t *node;
	const char *buf= [string cStringUsingEncoding:NSUTF8StringEncoding];
	NSUInteger l= [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

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
            // https://github.com/matthausen/twitter_demo/blob/769b322bcc810896738aa9c685d18eaebe89ed76/lib/python3.7/site-packages/spacy/lang/ja/__init__.py
            newNode.spacesAfter = spacesWithLength(node->next->rlength - node->next->length);
        } else {
            newNode.spacesAfter = @"";
        }
		[newNodes addObject:newNode];
	}
	
	return [NSArray arrayWithArray:newNodes];
}

- (void)dealloc {
	if (mecab != NULL) {
		mecab_destroy(mecab);
	}
}

@end
