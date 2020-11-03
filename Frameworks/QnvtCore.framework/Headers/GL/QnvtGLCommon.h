//
//  QnvtGLCommon.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef PiliGlCommon_h
#define PiliGlCommon_h

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(ANDROID) || defined(__ANDROID__)

#include "Platform/QnvtGL_Android.h"

#elif defined(IOS_SDK) || (defined(TARGET_OS_IOS) && TARGET_OS_IOS) || (defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE)
#ifndef IOS_SDK
#define IOS_SDK 1
#endif
#include "Platform/QnvtGL_iOS.h"
#endif

#include <stdio.h>
#include <string>

void qnvtCheckGLError();

#endif /* PiliGlCommon_h */
