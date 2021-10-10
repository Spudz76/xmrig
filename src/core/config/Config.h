/* XMRig
 * Copyright (c) 2018-2021 SChernykh   <https://github.com/SChernykh>
 * Copyright (c) 2016-2021 XMRig       <https://github.com/xmrig>, <support@xmrig.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef XMRIG_CONFIG_H
#define XMRIG_CONFIG_H


#include <cstdint>
#ifdef XMRIG_FEATURE_PAUSE_PROCESS
#include <vector>
#endif


#include "3rdparty/rapidjson/fwd.h"
#include "backend/cpu/CpuConfig.h"
#include "base/kernel/config/BaseConfig.h"
#include "base/tools/Object.h"
#ifdef XMRIG_FEATURE_MO_BENCHMARK
#include "core/MoBenchmark.h"
#endif


namespace xmrig {


class ConfigPrivate;
class CudaConfig;
class IThread;
class OclConfig;
class RxConfig;


class Config : public BaseConfig
{
public:
    XMRIG_DISABLE_COPY_MOVE(Config);

    static const char *kPauseOnBattery;
    static const char *kPauseOnActive;
#   ifdef XMRIG_FEATURE_PAUSE_PROCESS
    static const char *kPauseOnProcess;
#   endif

#   ifdef XMRIG_FEATURE_OPENCL
    static const char *kOcl;
#   endif

#   ifdef XMRIG_FEATURE_CUDA
    static const char *kCuda;
#   endif

#   if defined(XMRIG_FEATURE_NVML) || defined (XMRIG_FEATURE_ADL)
    static const char *kHealthPrintTime;
#   endif

#   ifdef XMRIG_FEATURE_DMI
    static const char *kDMI;
#   endif

    Config();
    ~Config() override;

    inline bool isPauseOnActive() const { return idleTime() > 0; }
#   ifdef XMRIG_FEATURE_PAUSE_PROCESS
    inline bool isPauseOnProcess() const { return !processList().empty(); }
#   endif

    bool isPauseOnBattery() const;
    const CpuConfig &cpu() const;
    uint32_t idleTime() const;
    std::vector<std::string> processList() const;
    rapidjson::Value getPauseProcesses(rapidjson::Document &doc) const;

#   ifdef XMRIG_FEATURE_OPENCL
    const OclConfig &cl() const;
#   endif

#   ifdef XMRIG_FEATURE_CUDA
    const CudaConfig &cuda() const;
#   endif

#   ifdef XMRIG_ALGO_RANDOMX
    const RxConfig &rx() const;
#   endif

#   if defined(XMRIG_FEATURE_NVML) || defined (XMRIG_FEATURE_ADL)
    uint32_t healthPrintTime() const;
#   else
    uint32_t healthPrintTime() const        { return 0; }
#   endif

#   ifdef XMRIG_FEATURE_DMI
    bool isDMI() const;
#   else
    static constexpr inline bool isDMI()    { return false; }
#   endif

    bool isShouldSave() const;
    bool read(const IJsonReader &reader, const char *fileName) override;
    void getJSON(rapidjson::Document &doc) const override;

#   ifdef XMRIG_FEATURE_MO_BENCHMARK
    inline MoBenchmark &benchmark() { return m_benchmark; }
#   endif

private:
    ConfigPrivate *d_ptr;
#   ifdef XMRIG_FEATURE_MO_BENCHMARK
    MoBenchmark m_benchmark;
#   endif
};


} /* namespace xmrig */


#endif /* XMRIG_CONFIG_H */
