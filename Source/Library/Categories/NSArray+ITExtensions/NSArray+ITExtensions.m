//
//  NSArray+ITExtensions.m
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 03.03.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

#import "NSArray+ITExtensions.h"

@implementation NSArray (ITExtensions)

#pragma mark -
#pragma mark Class Methods

+ (instancetype)objectsWithCount:(NSUInteger)count block:(id(^)())block {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < count; index++) {
        [array addObject:block()];
    }
    
    return [self arrayWithArray:array];
}

#pragma mark -
#pragma mark Public

- (id)objectWithClass:(Class)cls {
    for (id object in self) {
        if ([object isMemberOfClass:cls]) {
            return object;
        }
    }
    
    return nil;
}

@end
