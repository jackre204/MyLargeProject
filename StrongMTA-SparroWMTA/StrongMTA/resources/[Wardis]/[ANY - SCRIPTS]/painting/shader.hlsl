#include "mta-helper.fx"

float3 sCoordinate;
float4 sColor;

sampler SamplerColor = sampler_state
{
	Texture = (gTexture0);
};

struct VS_INPUT
{
	float4 Position : POSITION;
	float3 Normal : NORMAL0;
	float4 Diffuse : COLOR0;
	float2 TexCoord : TEXCOORD0;
	float3 View : TEXCOORD1;
};

struct VS_OUTPUT
{
	float4 Position : POSITION;
	float4 Diffuse : COLOR0;
	float2 TexCoord : TEXCOORD0;
	float3 View : TEXCOORD1;
	float4 WorldPos : TEXCOORD2;
	float3 Normal : TEXCOORD3;
};

struct PS_OUTPUT
{
	float4 Color : COLOR0;
};

VS_OUTPUT VertexShaderFunction(VS_INPUT VS)
{
	VS_OUTPUT PS = (VS_OUTPUT)0;

	float4 worldPos = mul(VS.Position, gWorld);
	float4 viewPos = mul(worldPos, gView);

	PS.WorldPos = float4(worldPos.xyz, viewPos.z / viewPos.w);
	PS.Position = mul(viewPos, gProjection);

	PS.View = gCameraPosition - worldPos.xyz;
	PS.Normal = normalize(mul(VS.Normal, (float3x3)gWorld));

	PS.TexCoord = VS.TexCoord;
	PS.Diffuse = MTACalcGTAVehicleDiffuse(PS.Normal, VS.Diffuse);

	return PS;
}

PS_OUTPUT PixelShaderFunction(VS_OUTPUT VS)
{
	PS_OUTPUT PS = (PS_OUTPUT)0;

	float DrawColor = pow(saturate(1.0 - distance(VS.WorldPos, sCoordinate)), 10.0);

	PS.Color = saturate((1.0 - DrawColor) * VS.Diffuse + DrawColor * sColor);

	return PS;
}

technique Advanced
{
	pass P0
	{
		AlphaBlendEnable = true;
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique Fallback
{
	pass P0 {}
}
