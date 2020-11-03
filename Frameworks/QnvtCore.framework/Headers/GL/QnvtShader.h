//
//  QnvtShader.h
//  QnvtCore
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtShader_h
#define QnvtShader_h

#include <string>

#define SHADER_STRING(...) #__VA_ARGS__

namespace QNVT {

// clang-format off
static const std::string g_passthrough_vertex =
SHADER_STRING(
    attribute vec4 position;
    attribute vec4 inputTextureCoordinate;
    varying vec2 textureCoordinate;
    void main() {
        gl_Position = position;
        textureCoordinate = inputTextureCoordinate.xy;
    });


static const std::string g_matrix_vertex =
SHADER_STRING(
    attribute vec4 position;
    attribute vec4 inputTextureCoordinate;
    uniform mat4 uMVPMatrix;
    varying vec2 textureCoordinate;
    void main() {
        gl_Position = position * uMVPMatrix;
        textureCoordinate = inputTextureCoordinate.xy;
    });

static const std::string g_passthrough_frag =
SHADER_STRING(
    varying highp vec2 textureCoordinate;
    uniform sampler2D inputImageTexture;
    void main() {
        gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
    });
// clang-format on

} // namespace QNVT

#endif /* QnvtShader_h */
