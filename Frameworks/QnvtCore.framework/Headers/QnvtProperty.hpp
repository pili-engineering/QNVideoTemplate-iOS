//
//  QnvtProperty.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/3/11.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtProperty_hpp
#define QnvtProperty_hpp

#include <stdio.h>
#include <string>
#include <variant>

namespace QNVT {

template<class... Ts>
struct overloaded : Ts... {
    using Ts::operator()...;
};
template<class... Ts>
overloaded(Ts...) -> overloaded<Ts...>;

struct PropertyValueBase {
    float inPoint; // specified as a frame index
    float outPoint;
};

struct PicturePropertyValueBase : public PropertyValueBase {
    int width;
    int height;
};

struct TextPropertyValue : public PropertyValueBase {
    std::string text;

    TextPropertyValue(std::string text);
    TextPropertyValue(std::string text, float inPoint, float outPoint);
    TextPropertyValue(const TextPropertyValue& old);
};

struct ImagePropertyValue : public PicturePropertyValueBase {
    std::string imagePath;

    ImagePropertyValue(std::string imagePath);
    ImagePropertyValue(std::string imagePath, int width, int height, float inPoint, float outPoint);
    ImagePropertyValue(const ImagePropertyValue& old);
};

struct VideoPropertyValue : public PicturePropertyValueBase {
    std::string videoPath;

    VideoPropertyValue(std::string videoPath);
    VideoPropertyValue(std::string videoPath, int width, int height, float inPoint, float outPoint);
    VideoPropertyValue(const VideoPropertyValue& old);
};

using PropertyValue = std::variant<TextPropertyValue, ImagePropertyValue, VideoPropertyValue>;

struct Property {
    enum PropertyType : int
    { //
        PropertyTypeText,
        PropertyTypeImage,
        PropertyTypeVideo
    };

    const int pid;
    PropertyType type;
    std::string name;
    PropertyValue value; //这里的value是对应的valuetype
};

} // namespace QNVT

#endif /* QnvtProperty_hpp */
