//
//  ITJSONRepresentation+ITExtensions.h
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 24.04.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITJSONRepresentation <NSObject>

- (instancetype)ITJSONRepresentation;

@end

@interface NSDictionary (ITExtensions)<ITJSONRepresentation>

@end

@interface NSArray (ITExtensions)<ITJSONRepresentation>

@end

@interface NSNumber (ITExtensions)<ITJSONRepresentation>

@end

@interface NSNull (ITExtensions)<ITJSONRepresentation>

@end

@interface NSString (ITExtensions)<ITJSONRepresentation>

@end
