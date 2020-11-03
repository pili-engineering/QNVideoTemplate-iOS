//
// Created by chenqian on 2020/8/4.
//

#ifndef QnvtGLTexture_h
#define QnvtGLTexture_h

#include "Common/QnvtGeometry.hpp"
#include "GL/QnvtGLCommon.h"

namespace QNVT {
struct TextureOptions {
    GLenum minFilter = GL_LINEAR;
    GLenum magFilter = GL_LINEAR;
    GLenum wrapS = GL_CLAMP_TO_EDGE;
    GLenum wrapT = GL_CLAMP_TO_EDGE;
    GLenum internalFormat = GL_RGBA;

    GLenum format = GL_RGBA;
    GLenum type = GL_UNSIGNED_BYTE;

    TextureOptions() = default;

    TextureOptions(GLenum format) : format(format){};
};

class GLTexture {
public:
    GLTexture(TextureOptions opt);

    ~GLTexture();

    GLuint id();

    void bind();

    void unbind();

    void texImage2D(const ISize& size, const void* pixel);

    const TextureOptions& options() const;

    const ISize& size() const;

private:
    GLuint mId;
    ISize mSize = MakeISize(0, 0);
    TextureOptions mOptions;
};
} // namespace QNVT

#endif // QnvtGLTexture_h
