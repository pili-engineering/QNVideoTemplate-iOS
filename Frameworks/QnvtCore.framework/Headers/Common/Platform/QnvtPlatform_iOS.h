//
//  QnvtPlatform_iOS.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtPlatform_iOS_h
#define QnvtPlatform_iOS_h

#include "Common/QnvtDefine.h"

#define qnvt_printflike(fmt, arg) __printflike(fmt, arg)
#define QNVTLOG(fmt, ...) printf(fmt, ##__VA_ARGS__)

namespace QNVT {

inline void QNVTLOG_V(LogLevel level, const char* fmt, va_list arg) {
    vprintf(fmt, arg);
}

} // namespace QNVT

#endif /* QnvtPlatform_iOS_h */
