//
//  PiliFrameBuffer.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef PiliFrameBuffer_hpp
#define PiliFrameBuffer_hpp

#include "Common/QnvtGeometry.hpp"
#include "GL/QnvtGLCommon.h"
#include "GL/QnvtGLContext.hpp"
#include "QnvtGLTexture.h"

#include <stdio.h>

namespace QNVT {

class GLFrameBuffer {
public:
    GLFrameBuffer(std::shared_ptr<GLContext> context, TextureOptions texOpt, ISize size);
    ~GLFrameBuffer();

    const ISize& bufferSize() const { return mSize; }
    const TextureOptions& textureOption() { return mTexture->options(); }
    GLuint textureId() { return mTexture->id(); }
    GLuint fbo() { return mFbo; }

    void resize(const ISize& size);
    void bind() const;
    void unbind() const;

    void enableStencilDepth(bool enable); // not implemented yet

private:
    ISize mSize;
    TextureOptions mTextureOption;
    std::shared_ptr<GLContext> mContext;
    std::unique_ptr<GLTexture> mTexture;
    GLuint mFbo;
    GLuint mRbo;

    bool mEnableStencilDepth;

    void genFramebuffer();
    void genStencilDepthBuffer();
};

} // namespace QNVT

#endif /* PiliFrameBuffer_hpp */
