//
//  QnvtMovieWriter.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtMovieWriter_hpp
#define QnvtMovieWriter_hpp

#include "GL/QnvtGLContext.hpp"
#include "QnvtAsset.hpp"
#include "QnvtVideoSetting.hpp"

#include <functional>
#include <memory>
#include <stdio.h>

namespace QNVT {

class MovieWriter {
public:
    using Callback = std::function<void(float percent, bool complete, bool success)>;

    enum class State : int8_t
    { //
        StateRunning,
        StatePause,
        StateStop
    };

    static std::unique_ptr<MovieWriter> MakeMovieWriter(std::shared_ptr<Asset> asset, std::unique_ptr<VideoSetting> setting);

    virtual ~MovieWriter();

    virtual void setVideoSetting(std::unique_ptr<VideoSetting> setting);
    virtual void setAsset(std::shared_ptr<Asset> asset);

    virtual void start(Callback progress);
    virtual void pause();
    virtual void resume();
    virtual void stop();

    virtual State state();

protected:
    MovieWriter();
};

} // namespace QNVT

#endif /* QnvtMovieWriter_hpp */
