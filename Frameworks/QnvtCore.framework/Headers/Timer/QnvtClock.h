//
//  QnvtClock.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#pragma once

#include <stdint.h>
#include <string>

namespace QNVT {

enum
{
    TIME_UNIT = int64_t(1000), // milliseconds, i.e. 1/1000 second
};

class Clock {
public:
    // Get current unix time in microseconds
    static int64_t CurrentTimeMicrosec();

    // current time units in milliseconds
    static int64_t CurrentTimeUnits();

    // Get current time in string format
    static std::string CurrentTimeString(int64_t milliseconds);

    // Get current tick count, in microseconds
    static uint64_t GetCurrentSystemTime();
};

} // namespace QNVT
