//
//  QnvtPlayer.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtPlayer_hpp
#define QnvtPlayer_hpp

#include "Common/QnvtCommonPriv.h"
#include "GL/QnvtGLContext.hpp"
#include "QnvtAsset.hpp"
#include "QnvtOutputTarget.hpp"
#include "QnvtProperty.hpp"

#include <memory>
#include <stdio.h>
#include <vector>

namespace QNVT {

enum class PlayerState : int
{
    Stop,
    Playing,
    Pause
};

enum class PlayerPlayMode : int
{
    Realtime,
    FrameAdvance
};

class Player {
public:
    virtual ~Player();

    static std::unique_ptr<Player> MakePlayer(std::shared_ptr<Asset> asset, QNVT::Size dimensionLimit, float fps = 0);
    virtual auto getReplaceableProperties() -> const std::vector<std::shared_ptr<Property>>&;
    virtual void setProperty(int pid, const PropertyValue& propertyValue);
    virtual void resetProperty(int pid);
    virtual void resetAllProperty();

    virtual PlayerState state();

    virtual void play();
    virtual void pause();
    virtual void resume();
    virtual void stop();
    virtual void setRate(float);
    virtual void setPlayMode(PlayerPlayMode);
    virtual void setBgm(const std::string& path);

    virtual void setBackgroudColor(float[4]);
    virtual void setOutputTarget(std::shared_ptr<OutputTarget> target);
    virtual void setStateObserver(std::function<void(PlayerState)>);
    virtual void setProgressObserver(std::function<void(double current)>);
    virtual void replaceCurrentAsset(std::shared_ptr<Asset> asset);

    virtual void seek(double time);
    virtual double duration();

    virtual auto currentAsset() -> std::shared_ptr<Asset>;

protected:
    Player() = default;
};

} // namespace QNVT

#endif /* QnvtPlayer_hpp */
