//
//  UINib+ITExtensions.h
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 02.03.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib (ITExtensions)

+ (UINib *)nibWithClass:(Class)cls;
+ (UINib *)nibWithClass:(Class)cls bundle:(NSBundle *)bundle;

+ (id)objectWithClass:(Class)cls;
+ (id)objectWithClass:(Class)cls bundle:(NSBundle *)bundle;
+ (id)objectWithClass:(Class)cls bundle:(NSBundle *)bundle withOwner:(id)owner withOptions:(NSDictionary *)options;

- (id)objectWithClass:(Class)cls;
- (id)objectWithClass:(Class)cls withOwner:(id)owner;
- (id)objectWithClass:(Class)cls withOwner:(id)owner withOptions:(NSDictionary *)options;

- (NSArray *)objectsWithOwner:(id)owner withOptions:(NSDictionary *)options;

@end
