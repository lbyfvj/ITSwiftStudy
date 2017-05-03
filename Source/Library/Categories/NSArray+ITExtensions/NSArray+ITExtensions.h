//
//  NSArray+ITExtensions.h
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 03.03.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ITExtensions)

+ (instancetype)objectsWithCount:(NSUInteger)count block:(id(^)())block;

- (id)objectWithClass:(Class)cls;

@end
