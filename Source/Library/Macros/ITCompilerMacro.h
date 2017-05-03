//
//  ITCompilerMacro.h
//  ITObjCUI
//
//  Created by Ivan Tsyganok on 07.03.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//


#define ITClnagDiagnosticPush _Pragma("clang diagnostic push")
#define ITClangDiagnosticPop _Pragma("clang diagnostic pop")

#define ITClangDiagnosticPushExpression(key) \
ITClnagDiagnosticPush; \
_Pragma(key)

#define ITClangDiagnosticPopExpression ITClangDiagnosticPop

