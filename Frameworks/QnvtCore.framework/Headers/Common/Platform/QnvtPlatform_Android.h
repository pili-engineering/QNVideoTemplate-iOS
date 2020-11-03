//
//  PiliPlatform_Adroid.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtPlatform_Android_h
#define QnvtPlatform_Android_h

#include "Common/QnvtDefine.h"

#include <android/log.h>

#define QNVTLOG_TAG "QNVT_ANDROID"
#define LOGD(FORMAT, ...) __android_log_print(ANDROID_LOG_DEBUG, QNVTLOG_TAG, FORMAT, ##__VA_ARGS__);
#define LOGI(FORMAT, ...) __android_log_print(ANDROID_LOG_INFO, QNVTLOG_TAG, FORMAT, ##__VA_ARGS__);
#define LOGW(FORMAT, ...) __android_log_print(ANDROID_LOG_WARN, QNVTLOG_TAG, FORMAT, ##__VA_ARGS__);
#define LOGE(FORMAT, ...) __android_log_print(ANDROID_LOG_ERROR, QNVTLOG_TAG, FORMAT, ##__VA_ARGS__);

#define QNVTLOG(fmt, ...) __android_log_print(ANDROID_LOG_INFO, QNVTLOG_TAG, fmt, ##__VA_ARGS__);
#define qnvt_printflike(fmt, arg) __printflike(fmt, arg)

namespace QNVT {

inline int get_android_log_level(LogLevel level) {
    switch (level) {
        case LogLevel::debug:
            return ANDROID_LOG_DEBUG;
        case LogLevel::info:
            return ANDROID_LOG_INFO;
        case LogLevel::warning:
            return ANDROID_LOG_WARN;
        case LogLevel::error:
            return ANDROID_LOG_ERROR;
        default:
            return ANDROID_LOG_DEFAULT;
    }
}

inline void QNVTLOG_V(LogLevel level, const char* fmt, va_list arg) {
    __android_log_vprint(get_android_log_level(level), QNVTLOG_TAG, fmt, arg);
}

} // namespace QNVT

#endif /* QnvtPlatform_Android_h */
