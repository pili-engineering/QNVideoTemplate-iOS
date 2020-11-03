//
//  QnvtOutputTarget.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtOutputTarget_hpp
#define QnvtOutputTarget_hpp

#include "GL/QnvtGLContext.hpp"
#include "GL/QnvtGLFrameBuffer.hpp"
#include "QnvtCommon.hpp"

#include <stdio.h>

namespace QNVT {

class OutputTarget {
public:
    virtual void didOutputFramebuffer(std::shared_ptr<QNVT::GLContext> context,
                                      const std::unique_ptr<QNVT::GLFrameBuffer>& framebuffer,
                                      const Time& timingInfo) = 0;

    virtual ~OutputTarget() = default;

protected:
    OutputTarget() = default;
};

} // namespace QNVT

#endif /* QnvtOutputTarget_hpp */
