//
//  QnvtCommon.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtCommon_hpp
#define QnvtCommon_hpp

#include "Common/QnvtDefine.h"

#include <assert.h>
#include <stdio.h>
#include <string>

namespace QNVT {

void setLicensePath(const std::string& path);
void setLogLevel(LogLevel level);

struct Time {
    int64_t value;
    int32_t scale;

    inline double seconds() const { return 1.0 * value / scale; }
};

} // namespace QNVT

#endif /* QnvtCommon_hpp */
