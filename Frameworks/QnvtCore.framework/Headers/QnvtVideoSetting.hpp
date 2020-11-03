//
//  QnvtVideoSetting.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtVideoSetting_hpp
#define QnvtVideoSetting_hpp

#include "Common/QnvtGeometry.hpp"

#include <stdio.h>
#include <string>

namespace QNVT {

struct VideoSetting {
    std::string outputPath;
    float fps = 0;                                  // 当前建议不要设置此参数，使用模板中的fps值
    QNVT::Size dimension = {1280, 1280};            // 必须是偶数
    bool dimensionExact = false;                    // 若是true，将用backgroundColor填充剩余区域
    float backgroudColor[4] = {1.0, 1.0, 1.0, 1.0}; // rgba 0.0 - 1.0;

    bool enableHWAccel = false;
    int64_t bitrate = 0;
};

} // namespace QNVT

#endif /* QnvtVideoSetting_hpp */
