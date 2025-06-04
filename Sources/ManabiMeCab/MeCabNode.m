//
//  MeCabNode.m
//
//  Created by Watanabe Toshinori on 10/12/22.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "MeCabNode.h"
#import <Foundation/Foundation.h>


@implementation MeCabNode

@synthesize surface;
@synthesize feature;
@synthesize features;
@synthesize featuresCount;
@synthesize spacesBefore;
@synthesize spacesAfter;

- (void)setFeature:(NSString *)value {
    if (value) {
        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *parts = [NSMutableArray array];
        NSUInteger length = [data length];
        const char *bytes = [data bytes];
        NSUInteger start = 0;
        for (NSUInteger i = 0; i < length; i++) {
            if (bytes[i] == ',') {
                NSRange range = NSMakeRange(start, i - start);
                NSString *part = [[NSString alloc] initWithBytes:bytes + start length:range.length encoding:NSUTF8StringEncoding];
                [parts addObject:part];
                start = i + 1;
            }
        }
        if (start <= length) {
            NSRange range = NSMakeRange(start, length - start);
            NSString *part = [[NSString alloc] initWithBytes:bytes + start length:range.length encoding:NSUTF8StringEncoding];
            [parts addObject:part];
        }
        feature = value;
        self.features = parts;
        self.featuresCount = parts.count;
    } else {
        feature = nil;
        self.features = nil;
        self.featuresCount = 0;
    }
}

- (NSString *)partOfSpeech {
    if (!features || featuresCount < 1) {
        return nil;
    }
    return features[0];
}

- (NSString *)partOfSpeechSubtype1 {
    if (!features || featuresCount < 2) {
        return nil;
    }
    return features[1];
}

- (NSString *)partOfSpeechSubtype2 {
    if (!features || featuresCount < 3) {
        return nil;
    }
    return features[2];
}

- (NSString *)partOfSpeechSubtype3 {
    if (!features || featuresCount < 4) {
        return nil;
    }
    return features[3];
}

- (NSString *)inflection {
    if (!features || featuresCount < 5) {
        return nil;
    }
    return features[4];
}

- (NSString *)useOfType {
    if (!features || featuresCount < 6) {
        return nil;
    }
    return features[5];
}

- (NSString *)originalForm {
    if (!features || featuresCount < 7) {
        return nil;
    }
    return features[6];
}

- (NSString *)reading {
    if (!features || featuresCount < 8) {
        return nil;
    }
    return features[7];
}

- (NSString *)pronunciation {
    if (!features || featuresCount < 9) {
        return nil;
    }
    return features[8];
}

- (void)dealloc {
    self.surface = nil;
    self.feature = nil;
    self.features = nil;
    self.spacesBefore = nil;
    self.spacesAfter = nil;
}

@end
