import torch
from diffusers import Flux2KleinPipeline
from nunchaku import NunchakuFlux2Transformer2DModel

MERGED = "./flux2_quant/svdq-int4_r32-flux.2-klein.safetensors"


BASE = "/data/chenchuang/flux_model/FLUX.2-klein-base-9B"

transformer = NunchakuFlux2Transformer2DModel.from_pretrained(MERGED, torch_dtype=torch.bfloat16)
pipe = Flux2KleinPipeline.from_pretrained(BASE, torch_dtype=torch.bfloat16, transformer=transformer).to("cuda")

img = pipe(
    prompt="a cute corgi sitting on a beach at sunset, highly detailed",
    num_inference_steps=30,
    guidance_scale=0,
    generator=torch.Generator("cpu").manual_seed(42),
).images[0]

img.save("./flux2_klein_int4.png")
print("saved ./flux2_klein_int4.png")
