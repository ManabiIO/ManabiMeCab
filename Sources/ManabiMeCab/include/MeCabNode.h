//
//  Node.h
//
//  Created by Watanabe Toshinori on 10/12/22.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeCabNode : NSObject {
    
    NSString *surface;
    NSString *feature;
    NSArray *features;
    NSUInteger featuresCount;
    NSString *spacesBefore;
    NSString *spacesAfter;
}

@property (nonatomic, retain) NSString *surface;
@property (nonatomic, retain) NSString *feature;
@property (nonatomic, retain) NSArray *features;
@property (nonatomic) NSUInteger featuresCount;
@property (nonatomic, retain) NSString *spacesBefore;
@property (nonatomic, retain) NSString *spacesAfter;

// 品詞
- (NSString *)partOfSpeech;
// 品詞細分類1
- (NSString *)partOfSpeechSubtype1;
// 品詞細分類2
- (NSString *)partOfSpeechSubtype2;
// 品詞細分類3
- (NSString *)partOfSpeechSubtype3;
// 活用形
- (NSString *)inflection;
// 活用型
- (NSString *)useOfType;
// 原形
- (NSString *)originalForm;
// 読み
- (NSString *)reading;
// 発音
- (NSString *)pronunciation;

@end
