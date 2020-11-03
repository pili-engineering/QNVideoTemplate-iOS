//
//  QnvtGLProgram.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/26.
//  Copyright © 2020 Hermes. All rights reserved.
//

#include "QnvtGLCommon.h"
#include "QnvtGLContext.hpp"

#include <map>
#include <string>

#ifndef QnvtGLProgram_hpp
#define QnvtGLProgram_hpp

namespace QNVT {

class GLProgram {
public:
    static GLProgram* loadProgramFromFile(const std::string& vertexPath, const std::string& fragmentPath, std::shared_ptr<GLContext> context);

    GLProgram(const std::string& vertex, const std::string& fragment, std::shared_ptr<GLContext> context);
    ~GLProgram();

    bool mInitialized;
    std::string mVertexShaderLog;
    std::string mFragmentShaderLog;
    std::string mProgramLog;

    GLuint bindAttribute(const std::string& attributeName);
    int attributeLocation(const std::string& attributeName);
    int uniformLocation(const std::string& uniformName);

    bool link();
    void bind();
    void unbind();
    void validate();

private:
    std::shared_ptr<GLContext> mContext;

    GLuint mProgram, mVertShader, mFragShader;
    GLuint mAttrubuteCounter = 0;

    std::map<std::string, GLuint> mAttributeLocMap;

    bool compileShader(GLuint& shaderid, GLenum shaderType, const std::string& shaderStr);
};

} // namespace QNVT

#endif
