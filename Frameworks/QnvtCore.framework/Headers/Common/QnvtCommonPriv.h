//
//  QnvtCommon.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtCommon_h
#define QnvtCommon_h

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(__ANDROID__)
#include "Platform/QnvtPlatform_Android.h"
#elif defined(IOS_SDK) || (defined(TARGET_OS_IOS) && TARGET_OS_IOS) || (defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE)
#ifndef IOS_SDK
#define IOS_SDK 1
#endif
#include "Platform/QnvtPlatform_iOS.h"
#endif

#include "functional"

// define kTimeStatCond in imp file to use time statistic
// static bool const kTimeStatCond = true;

#define QNVT_ENABLE_TIMESTATISTIC DEBUG && 1
#define QNVT_ENABLE_ASSERT DEBUG && 1

#if QNVT_ENABLE_ASSERT
#define QNVTASSERT(x) assert(x)
#else
#define QNVTASSERT(x)
#endif

#if QNVT_ENABLE_TIMESTATISTIC
#include "Timer/QnvtClock.h"
#define DRep(r, d) d
#define DTime(t) auto t = QNVT::Clock::CurrentTimeMicrosec()
#define DLog(...)                                                                                                                                    \
    do {                                                                                                                                             \
        if (kTimeStatCond) {                                                                                                                         \
            QNVTLOG(__VA_ARGS__);                                                                                                                    \
        }                                                                                                                                            \
    } while (0)
#else
#define DRep(r, d) r
#define DTime(t)
#define DLog(...)
#endif
#define Capt(...) [__VA_ARGS__]
#undef QNVT_ENABLE_TIMESTATISTIC

namespace QNVT {

class Defer {
public:
    Defer(std::function<void()> func) : mReleaseFunc(func){};
    ~Defer() { mReleaseFunc(); }

private:
    std::function<void()> mReleaseFunc;
};

static constexpr int32_t QNVT_TIME_BASE = 10000;
static constexpr int32_t QNVT_VIDEO_ENCODE_TIME_BASE = 100;
static constexpr int LOG_BUFFER_SIZE = 512;
static constexpr float DOWNSAMPLE_LENGTH = 512;
static constexpr float MAX_IMAGE_LENGTH = 2048;
static constexpr size_t GRCONTEXT_CACHE_SIZE = 1024 * 50;

class Logger {
public:
    static void log(LogLevel level, const char* format, ...) qnvt_printflike(2, 3);
    static void log(LogLevel level, const char* format, va_list arg) qnvt_printflike(2, 0);

    static inline void setLogLevel(LogLevel level) { sLevel = level; }
    static inline bool shouldLog(LogLevel level) { return (level != LogLevel::close && level <= sLevel); }

private:
    static LogLevel sLevel;
};

#ifdef DEBUG
inline LogLevel Logger::sLevel = LogLevel::debug;
#else
inline LogLevel Logger::sLevel = LogLevel::warning;
#endif

} // namespace QNVT

#endif /* QnvtCommon_h */
