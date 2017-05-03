//
//  ITBlockVariablesMacro.h
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 26.03.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

#import "ITCompilerMacro.h"

#define ITWeakify(variable) \
    __weak __typeof(variable) __ITWeakified_##variable = variable;

// you should only call this method after you called weakify for the same variable
#define ITStrongify(variable) \
    ITClangDiagnosticPushExpression("clang diagnostic ignored \"-Wshadow\""); \
    __strong __typeof(variable) variable = __ITWeakified_##variable; \
    ITClangDiagnosticPopExpression;

#define ITEmptyResult

#define ITStrongifyAndReturnIfNil(variable) \
    ITStrongifyAndReturnResultIfNil(variable, ITEmptyResult) \

#define ITStrongifyAndReturnNilIfNil(variable) \
    ITStrongifyAndReturnResultIfNil(variable, nil)

#define ITStrongifyAndReturnResultIfNil(variable, result) \
    ITStrongify(variable); \
    if (!variable) { \
        return result; \
    }

#define ITDispatchBlock(block, ...) \
    if (block) { \
        block (__VA_ARGS__); \
    }

#define ITValueBlock(block, variable, ...) \
    if (block) { \
        variable = block(__VA_ARGS__); \
    }

#define ITReturnSharedInstance(block) \
    static id sharedInstance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance = block(); \
    }); \
    \
    return sharedInstance;

#define ITReturnSharedInstanceWithBlock(block) \
    static id sharedInstance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        ITValueBlock(block, sharedInstance); \
    }); \
    \
    return sharedInstance;


