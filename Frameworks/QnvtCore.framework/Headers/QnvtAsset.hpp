//
//  QnvtAsset.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtAsset_hpp
#define QnvtAsset_hpp

#include "Common/QnvtGeometry.hpp"
#include "GL/QnvtGLContext.hpp"
#include "QnvtCommon.hpp"
#include "QnvtProperty.hpp"

#include <stdio.h>
#include <string>
#include <vector>

namespace QNVT {

class Asset {
public:
    virtual ~Asset();

    static std::unique_ptr<Asset> MakeAsset(const std::string& rootPath, std::shared_ptr<QNVT::GLContext> context);

    virtual const QNVT::Size& size();
    virtual double duration();
    virtual double fps();
    virtual auto context() -> std::shared_ptr<QNVT::GLContext>;

    virtual auto bgmPath() -> const std::string&;
    virtual auto getReplaceableProperties() -> const std::vector<std::shared_ptr<Property>>&;

protected:
    Asset() = default;
};

} // namespace QNVT

#endif /* QnvtAsset_hpp */
