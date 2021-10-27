#include <vector>

#include "kernels.h"
#include "pluginsRT/ActivationLogisticRT.h"

// Static class fields initialization
namespace tk { namespace dnn {
nvinfer1::PluginFieldCollection ActivationLogisticRTCreator::mFC{};
std::vector<nvinfer1::PluginField> ActivationLogisticRTCreator::mPluginAttributes;

REGISTER_TENSORRT_PLUGIN(ActivationLogisticRTCreator);
}}

__global__
void activation_logistic(dnnType *input, dnnType *output, int size) {

    int i = blockDim.x*blockIdx.x + threadIdx.x;

    if(i<size) {
        output[i] =  1.0f/(1.0f + exp(-input[i]));;
    }
 }


/**
    LOGISTIC activation function
*/
void activationLOGISTICForward(dnnType* srcData, dnnType* dstData, int size, cudaStream_t stream)
{
    int blocks = (size+255)/256;
    int threads = 256;

    activation_logistic<<<blocks, threads, 0, stream>>>(srcData, dstData, size);
}