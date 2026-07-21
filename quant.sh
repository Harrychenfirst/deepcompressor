export ALL_PROXY="http://public-proxy.qihoo.net:3128"
export PYTORCH_ALLOC_CONF=expandable_segments:True

source ./.venv/bin/activate

cd ./examples/diffusion

rm -rf ./.tmp datasets runs exports
find . -type d -name "__pycache__" -exec rm -rf {} \;

python3 -m deepcompressor.app.diffusion.ptq configs/model/flux.2-klein.yaml --output-dirname reference --eval-num-samples 5000

python3 -m deepcompressor.app.diffusion.dataset.collect.calib configs/model/flux.2-klein.yaml configs/collect/qdiff.yaml

python3 -m deepcompressor.app.diffusion.ptq \
    configs/model/flux.2-klein.yaml configs/svdquant/int4.yaml \
    --eval-benchmarks MJHQ --eval-num-samples 5000 --save-model true

# python3 -m deepcompressor.backend.nunchaku.convert \
#     --quant-path ./runs/diffusion/flux.2/flux.2-klein-base-9b/w.4-x.4-y.16/w.sint4-x.sint4.u-y.bf16/w.v64.bf16-x.v64.bf16-y.tnsr.bf16/smooth.proj-w.static.lowrank/shift-skip.x.[[w]+tan+tn].w.[e+rs+rtp+s+tpi+tpo]-low.r32.i100.e.skip.[rc+tan+tn]-smth.proj.GridSearch.bn2.[AbsMax].lr.skip.[rc+tan+tn]-qdiff.128-t30.g0-s5000.RUNNING/run-260717.194008/model \
#     --output-root ../../flux2_quant \
#     --model-name flux.2-klein


# python3 -m nunchaku.merge_safetensors \
#   -i ../../flux2_quant/flux.2-klein \
#   -m NunchakuFlux2Transformer2DModel \
#   -o ../../flux2_quant/svdq-int4_r32-flux.2-klein.safetensors