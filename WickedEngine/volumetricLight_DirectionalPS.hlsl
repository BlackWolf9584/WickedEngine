#include "deferredLightHF.hlsli"
#include "fogHF.hlsli"

float4 main(VertexToPixel input) : SV_TARGET
{
	ShaderEntityType light = EntityArray[(uint)g_xColor.x];

	if (light.additionalData_index < 0)
	{
		// Dirlight volume has no meaning without shadows!!
		return 0;
	}

	float2 ScreenCoord = input.pos2D.xy / input.pos2D.w * float2(0.5f, -0.5f) + 0.5f;
	float depth = max(input.pos.z, texture_depth.SampleLevel(sampler_linear_clamp, ScreenCoord, 0));
	float3 P = getPosition(ScreenCoord, depth);
	float3 V = g_xCamera_CamPos - P;
	float cameraDistance = length(V);
	V /= cameraDistance;

	float marchedDistance = 0;
	float3 accumulation = 0;

	const float3 L = light.directionWS;

	// Perform ray marching to integrate light volume along view ray:
	float sum = 0;
	while (marchedDistance < cameraDistance)
	{
		float3 attenuation = 1;

		float4 ShPos = mul(float4(P, 1), MatrixArray[light.additionalData_index + 0]);
		ShPos.xyz /= ShPos.w;
		float3 ShTex = ShPos.xyz * float3(0.5f, -0.5f, 0.5f) + 0.5f;

		[branch]if ((saturate(ShTex.x) == ShTex.x) && (saturate(ShTex.y) == ShTex.y) && (saturate(ShTex.z) == ShTex.z))
		{
			attenuation *= shadowCascade(ShPos, ShTex.xy, light.shadowKernel, light.shadowBias, light.additionalData_index + 0);
		}

		attenuation *= GetFog(cameraDistance - marchedDistance);

		accumulation += attenuation;

		const float stepSize = 0.5f;
		marchedDistance += stepSize;
		P = P + V * stepSize;

		sum += 1.0f;
	}

	accumulation /= sum;

	return max(0, float4(accumulation * light.GetColor().rgb * light.energy, 1));
}