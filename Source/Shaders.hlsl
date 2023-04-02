
cbuffer cbPlayerInfo : register(b0)
{
	matrix		gmtxPlayerWorld : packoffset(c0);
};

cbuffer cbCameraInfo : register(b1)
{
	matrix		gmtxView : packoffset(c0);
	matrix		gmtxProjection : packoffset(c4);
	matrix		gmtxViewProjection : packoffset(c8);
	float3		gvCameraPosition : packoffset(c12);
};

struct MATERIAL //c9개 루나책 확인해보기 패딩, 패킹부분
{
	float4				m_cAmbient; //c4
	float4				m_cDiffuse; //c5
	float4				m_cSpecular; //a = power //c6
	float4				m_cEmissive; //c7

	matrix				gmtxTexture; //c8 9 10 11
	int2				gi2TextureTiling; //c12.xy
	float2				gf2TextureOffset; //c12.zw
};

cbuffer cbGameObjectInfo : register(b2)
{
	matrix		gmtxWorld : packoffset(c0);
	MATERIAL	gMaterial : packoffset(c4);
	uint		gnMaterialID: packoffset(c13);
};
#include "Light.hlsl"

cbuffer cbFrameworkInfo : register(b5)
{
	float		gfCurrentTime : packoffset(c0.x);
	float		gfElapsedTime : packoffset(c0.y);
	uint		gnRenderMode : packoffset(c0.z);
};
//#endif
#define DYNAMIC_TESSELLATION		0x10
#define DEBUG_TESSELLATION			0x20

struct CB_TOOBJECTSPACE
{
	matrix		mtxToTexture;
	float4		f4Position;
};

cbuffer cbToLightSpace : register(b6)
{
	CB_TOOBJECTSPACE gcbToLightSpaces[MAX_LIGHTS];
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
struct VS_DIFFUSED_INPUT
{
	float3 position : POSITION;
	float4 color : COLOR;
};

struct VS_DIFFUSED_OUTPUT
{
	float4 position : SV_POSITION;
	float4 color : COLOR;
};

VS_DIFFUSED_OUTPUT VSDiffused(VS_DIFFUSED_INPUT input)
{
	VS_DIFFUSED_OUTPUT output;

#ifdef _WITH_CONSTANT_BUFFER_SYNTAX
	output.position = mul(mul(mul(float4(input.position, 1.0f), gcbGameObjectInfo.mtxWorld), gcbCameraInfo.mtxView), gcbCameraInfo.mtxProjection);
#else
	output.position = mul(mul(mul(float4(input.position, 1.0f), gmtxWorld), gmtxView), gmtxProjection);
#endif
	output.color = input.color;

	return(output);
}

float4 PSDiffused(VS_DIFFUSED_OUTPUT input) : SV_TARGET
{
	return(input.color);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
VS_DIFFUSED_OUTPUT VSPlayer(VS_DIFFUSED_INPUT input)
{
	VS_DIFFUSED_OUTPUT output;

#ifdef _WITH_CONSTANT_BUFFER_SYNTAX
	output.position = mul(mul(mul(float4(input.position, 1.0f), gcbPlayerObjectInfo.mtxWorld), gcbCameraInfo.mtxView), gcbCameraInfo.mtxProjection);
#else
	output.position = mul(mul(mul(float4(input.position, 1.0f), gmtxPlayerWorld), gmtxView), gmtxProjection);
#endif
	output.color = input.color;

	return(output);
}

float4 PSPlayer(VS_DIFFUSED_OUTPUT input) : SV_TARGET
{
	return(input.color);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

Texture2D gtxtTextures[6] : register(t0);
Texture2D gtxtTexture : register(t8);

SamplerState gWrapSamplerState : register(s0);
SamplerState gClampSamplerState : register(s1);

struct VS_TEXTURED_INPUT
{
	float3 position : POSITION;
	float2 uv : TEXCOORD;
};

struct VS_TEXTURED_OUTPUT
{
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD;
};

VS_TEXTURED_OUTPUT VSTextured(VS_TEXTURED_INPUT input)
{
	VS_TEXTURED_OUTPUT output;

	output.position = mul(mul(mul(float4(input.position, 1.0f), gmtxWorld), gmtxView), gmtxProjection);
	output.uv = input.uv;

	return(output);
}

float4 PSTextured(VS_TEXTURED_OUTPUT input, uint nPrimitiveID : SV_PrimitiveID) : SV_TARGET
{
	float4 cColor = gtxtTextures[NonUniformResourceIndex(nPrimitiveID/2)].Sample(gWrapSamplerState, input.uv);

	return(cColor);
}

VS_TEXTURED_OUTPUT VSSpriteAnimation(VS_TEXTURED_INPUT input)
{
	VS_TEXTURED_OUTPUT output;

	output.position = mul(mul(mul(float4(input.position, 1.0f), gmtxWorld), gmtxView), gmtxProjection);
	output.uv = mul(float3(input.uv, 1.0f), (float3x3)(gMaterial.gmtxTexture)).xy;

	return(output);
}
float4 PSSTextured(VS_TEXTURED_OUTPUT input) : SV_TARGET
{
	float4 cColor = gtxtTexture.Sample(gWrapSamplerState, input.uv);

	return(cColor);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
Texture2D gtxtTerrainBaseTexture : register(t6);
Texture2D gtxtTerrainDetailTexture : register(t7);
//Texture2D gtxtTerrainDetailTexture2 : register(t);

struct VS_TERRAIN_INPUT
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 uv0 : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
};

struct VS_TERRAIN_OUTPUT
{
	//float4 position : SV_POSITION;
	float3 position : POSITION;
	float3 positionW : POSITION1;//wORLD변환한 위치
	float4 color : COLOR;
	float2 uv0 : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
};

VS_TERRAIN_OUTPUT VSTerrain(VS_TERRAIN_INPUT input)
{
	VS_TERRAIN_OUTPUT output;

	output.position = input.position;
	output.positionW = mul(float4(input.position, 1.0f), gmtxWorld).xyz;
	output.color = input.color;
	output.uv0 = input.uv0;
	output.uv1 = input.uv1;

	return(output);
}
struct HS_TERRAIN_TESSELLATION_CONSTANT
{
	float fTessEdges[4] : SV_TessFactor;
	float fTessInsides[2] : SV_InsideTessFactor;
};

struct HS_TERRAIN_TESSELLATION_OUTPUT
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 uv0 : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
};

struct DS_TERRAIN_TESSELLATION_OUTPUT
{
	float4 position : SV_POSITION;
	float4 color : COLOR;
	float2 uv0 : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
	float4 tessellation : TEXCOORD2;
};

[domain("quad")]
//[partitioning("fractional_even")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(25)]
[patchconstantfunc("HSTerrainTessellationConstant")]
[maxtessfactor(64.0f)]
HS_TERRAIN_TESSELLATION_OUTPUT HSTerrainTessellation(InputPatch<VS_TERRAIN_OUTPUT, 25> input, uint i : SV_OutputControlPointID)
{
	HS_TERRAIN_TESSELLATION_OUTPUT output;

	output.position = input[i].position;
	output.color = input[i].color;
	output.uv0 = input[i].uv0;
	output.uv1 = input[i].uv1;

	return(output);
}

float CalculateTessFactor(float3 f3Position)
{
	float fDistToCamera = distance(f3Position, gvCameraPosition);
	float s = saturate((fDistToCamera - 10.0f) / (500.0f - 10.0f));

	return(lerp(64.0f, 1.0f, s));
	//	return(pow(2, lerp(20.0f, 4.0f, s)));
}

HS_TERRAIN_TESSELLATION_CONSTANT HSTerrainTessellationConstant(InputPatch<VS_TERRAIN_OUTPUT, 25> input)
{
	HS_TERRAIN_TESSELLATION_CONSTANT output;

	if (gnRenderMode & DYNAMIC_TESSELLATION)
	{
		float3 e0 = 0.5f * (input[0].positionW + input[4].positionW);
		float3 e1 = 0.5f * (input[0].positionW + input[20].positionW);
		float3 e2 = 0.5f * (input[4].positionW + input[24].positionW);
		float3 e3 = 0.5f * (input[20].positionW + input[24].positionW);

		output.fTessEdges[0] = CalculateTessFactor(e0);
		output.fTessEdges[1] = CalculateTessFactor(e1);
		output.fTessEdges[2] = CalculateTessFactor(e2);
		output.fTessEdges[3] = CalculateTessFactor(e3);

		float3 f3Sum = float3(0.0f, 0.0f, 0.0f);
		for (int i = 0; i < 25; i++) f3Sum += input[i].positionW;
		float3 f3Center = f3Sum / 25.0f;
		output.fTessInsides[0] = output.fTessInsides[1] = CalculateTessFactor(f3Center);
	}
	else
	{
		output.fTessEdges[0] = 20.0f;
		output.fTessEdges[1] = 20.0f;
		output.fTessEdges[2] = 20.0f;
		output.fTessEdges[3] = 20.0f;

		output.fTessInsides[0] = 20.0f;
		output.fTessInsides[1] = 20.0f;
	}

	return(output);
}

void BernsteinCoeffcient5x5(float t, out float fBernstein[5]) // 5X5기때문에 배열로 넘긴다
{
	float tInv = 1.0f - t;
	fBernstein[0] = tInv * tInv * tInv * tInv;
	fBernstein[1] = 4.0f * t * tInv * tInv * tInv;
	fBernstein[2] = 6.0f * t * t * tInv * tInv;
	fBernstein[3] = 4.0f * t * t * t * tInv;
	fBernstein[4] = t * t * t * t;
}

float3 CubicBezierSum5x5(OutputPatch<HS_TERRAIN_TESSELLATION_OUTPUT, 25> patch, float uB[5], float vB[5]) // U - 가로로 LERP V 세로로 LERP
{
	float3 f3Sum = float3(0.0f, 0.0f, 0.0f);
	f3Sum = vB[0] * (uB[0] * patch[0].position + uB[1] * patch[1].position + uB[2] * patch[2].position + uB[3] * patch[3].position + uB[4] * patch[4].position);
	f3Sum += vB[1] * (uB[0] * patch[5].position + uB[1] * patch[6].position + uB[2] * patch[7].position + uB[3] * patch[8].position + uB[4] * patch[9].position);
	f3Sum += vB[2] * (uB[0] * patch[10].position + uB[1] * patch[11].position + uB[2] * patch[12].position + uB[3] * patch[13].position + uB[4] * patch[14].position);
	f3Sum += vB[3] * (uB[0] * patch[15].position + uB[1] * patch[16].position + uB[2] * patch[17].position + uB[3] * patch[18].position + uB[4] * patch[19].position);
	f3Sum += vB[4] * (uB[0] * patch[20].position + uB[1] * patch[21].position + uB[2] * patch[22].position + uB[3] * patch[23].position + uB[4] * patch[24].position);

	return(f3Sum);
}

[domain("quad")]
DS_TERRAIN_TESSELLATION_OUTPUT DSTerrainTessellation(HS_TERRAIN_TESSELLATION_CONSTANT patchConstant, float2 uv : SV_DomainLocation, OutputPatch<HS_TERRAIN_TESSELLATION_OUTPUT, 25> patch)
{
	DS_TERRAIN_TESSELLATION_OUTPUT output = (DS_TERRAIN_TESSELLATION_OUTPUT)0;

	float uB[5], vB[5];
	BernsteinCoeffcient5x5(uv.x, uB); //가로에대해서 베른슈타인곡선 계산
	BernsteinCoeffcient5x5(uv.y, vB); //세로에대해서 베른슈타인곡선 계산

	output.color = lerp(lerp(patch[0].color, patch[4].color, uv.x), lerp(patch[20].color, patch[24].color, uv.x), uv.y);
	output.uv0 = lerp(lerp(patch[0].uv0, patch[4].uv0, uv.x), lerp(patch[20].uv0, patch[24].uv0, uv.x), uv.y);
	output.uv1 = lerp(lerp(patch[0].uv1, patch[4].uv1, uv.x), lerp(patch[20].uv1, patch[24].uv1, uv.x), uv.y);

	float3 position = CubicBezierSum5x5(patch, uB, vB); //곡면위의 제어점을 구함
	matrix mtxWorldViewProjection = mul(mul(gmtxWorld, gmtxView), gmtxProjection);
	output.position = mul(float4(position, 1.0f), mtxWorldViewProjection);

	output.tessellation = float4(patchConstant.fTessEdges[0], patchConstant.fTessEdges[1], patchConstant.fTessEdges[2], patchConstant.fTessEdges[3]);

	return(output);
}

float4 PSTerrain(DS_TERRAIN_TESSELLATION_OUTPUT input) : SV_TARGET
{
	float4 cColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
	if (gnRenderMode & (DEBUG_TESSELLATION | DYNAMIC_TESSELLATION))
	{
		if (input.tessellation.w <= 5.0f) cColor = float4(1.0f, 0.0f, 0.0f, 1.0f);
		else if (input.tessellation.w <= 10.0f) cColor = float4(0.0f, 1.0f, 0.0f, 1.0f);
		else if (input.tessellation.w <= 20.0f) cColor = float4(0.0f, 0.0f, 1.0f, 1.0f);
		else if (input.tessellation.w <= 30.0f) cColor = float4(1.0f, 0.0f, 1.0f, 1.0f);
		else if (input.tessellation.w <= 40.0f) cColor = float4(1.0f, 1.0f, 0.0f, 1.0f);
		else if (input.tessellation.w <= 50.0f) cColor = float4(1.0f, 1.0f, 1.0f, 1.0f);
		else if (input.tessellation.w <= 55.0f) cColor = float4(0.2f, 0.2f, 0.72f, 1.0f);
		else if (input.tessellation.w <= 60.0f) cColor = float4(0.5f, 0.75f, 0.75f, 1.0f);
		else cColor = float4(0.87f, 0.17f, 1.0f, 1.0f);
	}
	else
	{
		float4 cBaseTexColor = gtxtTerrainBaseTexture.Sample(gWrapSamplerState, input.uv0);
		float4 cDetailTexColor = gtxtTerrainDetailTexture.Sample(gWrapSamplerState, input.uv1);//TerrainDetail
		//float4 cDetailTexColor2 = gtxtTerrainDetailTexture2.Sample(gWrapSamplerState, input.uv2);
		cColor = saturate((cBaseTexColor * 0.5f) + (cDetailTexColor * 0.5f));
	}
	

	return(cColor);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
Texture2D gtxtSkyBox : register(t9);

float4 PSSkyBox(VS_TEXTURED_OUTPUT input) : SV_TARGET
{
	float4 cColor = gtxtSkyBox.Sample(gClampSamplerState, input.uv);

	return(cColor);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
#define _WITH_BILLBOARD_ANIMATION

struct VS_BILLBOARD_INSTANCING_INPUT
{
	float3 position : POSITION;
	float2 uv : TEXCOORD;
	float3 instancePosition : INSTANCEPOSITION;
	float4 billboardInfo : BILLBOARDINFO; //(cx, cy, type, texture)
};

struct VS_BILLBOARD_INSTANCING_OUTPUT
{
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD;
	int textureID : TEXTUREID;
};

#define _WITH_BILLBOARD_ANIMATION

VS_BILLBOARD_INSTANCING_OUTPUT VSBillboardInstancing(VS_BILLBOARD_INSTANCING_INPUT input)
{
	VS_BILLBOARD_INSTANCING_OUTPUT output;

	input.position.x *= (input.billboardInfo.x * 0.5f);
	input.position.y *= (input.billboardInfo.y * 0.5f);

	float3 f3Look = normalize(gvCameraPosition - input.instancePosition);
	float3 f3Up = float3(0.0f, 1.0f, 0.0f);
	float3 f3Right = normalize(cross(f3Up, f3Look));

	matrix mtxWorld;
	mtxWorld[0] = float4(f3Right, 0.0f);
	mtxWorld[1] = float4(f3Up, 0.0f);
	mtxWorld[2] = float4(f3Look, 0.0f);
	mtxWorld[3] = float4(input.instancePosition, 1.0f);

	output.position = mul(mul(mul(float4(input.position, 1.0f), mtxWorld), gmtxView), gmtxProjection);

#ifdef _WITH_BILLBOARD_ANIMATION
	if (input.uv.y < 0.7f)
	{
		float fShift = 0.0f;
		uint nResidual = ((uint)gfCurrentTime % 4);
		if (nResidual == 1) fShift = -gfElapsedTime * 10.5f;
		if (nResidual == 3) fShift = +gfElapsedTime * 10.5f;
		input.uv.x += fShift;
	}
#endif
	output.uv = input.uv;

	output.textureID = (int)input.billboardInfo.w - 1;

	return(output);
}

Texture2D<float4> gtxtBillboardTextures[7] : register(t10);

float4 PSBillboardInstancing(VS_BILLBOARD_INSTANCING_OUTPUT input) : SV_TARGET
{
	float4 cColor = gtxtBillboardTextures[NonUniformResourceIndex(input.textureID)].Sample(gWrapSamplerState, input.uv);

	return(cColor);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
VS_DIFFUSED_OUTPUT VSBullet(VS_DIFFUSED_INPUT input)
{
	VS_DIFFUSED_OUTPUT output;

	output.position = mul(mul(mul(float4(input.position, 1.0f), gmtxWorld), gmtxView), gmtxProjection);
	output.color = input.color;

	return(output);
}

float4 PSBullet(VS_DIFFUSED_OUTPUT input) : SV_TARGET
{
	return(input.color);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

struct VS_LIGHTING_INPUT
{
	float3	position    : POSITION;
	float3	normal		: NORMAL;
};

struct VS_LIGHTING_OUTPUT
{
	float4	position    : SV_POSITION;
	float3	positionW   : POSITION;
	float3	normalW		: NORMAL;
};

VS_LIGHTING_OUTPUT VSCubeMapping(VS_LIGHTING_INPUT input)
{
	VS_LIGHTING_OUTPUT output;

	output.positionW = mul(float4(input.position, 1.0f), gmtxWorld).xyz;
	output.normalW = mul(float4(input.normal, 0.0f), gmtxWorld).xyz;
	output.position = mul(mul(float4(output.positionW, 1.0f), gmtxView), gmtxProjection);

	return(output);
}

TextureCube gtxtCubeMap : register(t17);

float4 PSCubeMapping(VS_LIGHTING_OUTPUT input) : SV_Target
{
	input.normalW = normalize(input.normalW);

	float4 cIllumination = Lighting(input.positionW, input.normalW);

	float3 f3FromCamera = normalize(input.positionW - gvCameraPosition.xyz);
	float3 f3Reflected = normalize(reflect(f3FromCamera, input.normalW));
	float4 cCubeTextureColor = gtxtCubeMap.Sample(gWrapSamplerState, f3Reflected);

	return(cIllumination * cCubeTextureColor);
}

VS_LIGHTING_OUTPUT VSLighting(VS_LIGHTING_INPUT input)
{
	VS_LIGHTING_OUTPUT output;

	output.normalW = mul(input.normal, (float3x3)gmtxWorld);
	output.positionW = mul(float4(input.position, 1.0f), gmtxWorld).xyz;
	output.position = mul(mul(float4(output.positionW, 1.0f), gmtxView), gmtxProjection);

	return(output);
}

float4 PSLighting(VS_LIGHTING_OUTPUT input) : SV_TARGET
{
	input.normalW = normalize(input.normalW);
	float4 cColor = float4(input.normalW * 0.5f + 0.5f, 1.0f);


	return(float4(input.normalW * 0.5f + 0.5f, 1.0f));

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
struct PS_DEPTH_OUTPUT
{
	float fzPosition : SV_Target;
	float fDepth : SV_Depth;
};

PS_DEPTH_OUTPUT PSDepthWriteShader(VS_LIGHTING_OUTPUT input)
{
	PS_DEPTH_OUTPUT output;

	output.fzPosition = input.position.z;
	output.fDepth = input.position.z;

	return(output);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
struct VS_SHADOW_MAP_OUTPUT
{
	float4 position : SV_POSITION;
	float3 positionW : POSITION;
	float3 normalW : NORMAL;

	float4 uvs[MAX_LIGHTS] : TEXCOORD0;
};

VS_SHADOW_MAP_OUTPUT VSShadowMapShadow(VS_LIGHTING_INPUT input)
{
	VS_SHADOW_MAP_OUTPUT output = (VS_SHADOW_MAP_OUTPUT)0;

	float4 positionW = mul(float4(input.position, 1.0f), gmtxWorld);
	output.positionW = positionW.xyz;
	output.position = mul(mul(positionW, gmtxView), gmtxProjection);
	output.normalW = mul(float4(input.normal, 0.0f), gmtxWorld).xyz;

	for (int i = 0; i < MAX_LIGHTS; i++)
	{
		if (gcbToLightSpaces[i].f4Position.w != 0.0f) output.uvs[i] = mul(positionW, gcbToLightSpaces[i].mtxToTexture);
	}

	return(output);
}

float4 PSShadowMapShadow(VS_SHADOW_MAP_OUTPUT input) : SV_TARGET
{
	float4 cIllumination = Lighting2(input.positionW, normalize(input.normalW), true, input.uvs);
	
	return(cIllumination);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
#define PARTICLE_TYPE_EMITTER	0
#define PARTICLE_TYPE_FLARE		0x0ff

static float2 gf2QuadUVs[4] = { float2(0.0f,1.0f), float2(0.0f,0.0f), float2(1.0f,1.0f), float2(1.0f,0.0f) };

Texture2D<float4> gtxtParticleTexture : register(t18);
Buffer<float4> gRandomBuffer : register(t19); //텍스처를 버퍼로쓴다?

struct VS_PARTICLE_INPUT
{
	float3 position : POSITION;
	float3 color : COLOR;
	float3 velocity : VELOCITY;
	float3 acceleration : ACCELERATION;
	float2 size : SIZE;
	float2 age : AGELIFETIME; //(Age, Lifetime)
	uint type : PARTICLETYPE;
};

struct GS_PARTICLE_OUTPUT
{
	float4 position : SV_Position;
	float3 color : COLOR;
	float2 uv : TEXCOORD;
	float2 age : AGELIFETIME; //(Age, Lifetime)
	uint type : PARTICLETYPE;
};

VS_PARTICLE_INPUT VSParticleStreamOutput(VS_PARTICLE_INPUT input)
{
	return(input);
}


VS_PARTICLE_INPUT VSParticleDraw(VS_PARTICLE_INPUT input)
{
	//VS_PARTICLE_INPUT output = intput;
	//output.type = input.type;
	//float t = input.age;
	//output.position = (0.5f * input.acceleration * t * t) + (input.velocity * t) + input.position;
	return(input);
}

float3 GetParticleColor(float fAge, float fLifetime)
{
	float3 cColor = float3(1.0f, 1.0f, 1.0f);

	if (fAge == 0.0f) cColor = float3(0.0f, 1.0f, 0.0f);
	else if (fLifetime == 0.0f)
		cColor = float3(1.0f, 1.0f, 0.0f);
	else
	{
		float t = fAge / fLifetime;
		cColor = lerp(float3(1.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 1.0f), t * 1.0f);
	}

	return(cColor);
}


void GetBillboardCorners(float3 position, float2 size, out float4 pf4Positions[4])
{
	float3 f3Up = float3(0.0f, 1.0f, 0.0f);
	float3 f3Look = normalize(gvCameraPosition - position);
	float3 f3Right = normalize(cross(f3Up, f3Look));

	pf4Positions[0] = float4(position + size.x * f3Right - size.y * f3Up, 1.0f);
	pf4Positions[1] = float4(position + size.x * f3Right + size.y * f3Up, 1.0f);
	pf4Positions[2] = float4(position - size.x * f3Right - size.y * f3Up, 1.0f);
	pf4Positions[3] = float4(position - size.x * f3Right + size.y * f3Up, 1.0f);
}

void GetPositions(float3 position, float2 f2Size, out float3 pf3Positions[8])
{
	float3 f3Right = float3(1.0f, 0.0f, 0.0f);
	float3 f3Up = float3(0.0f, 1.0f, 0.0f);
	float3 f3Look = float3(0.0f, 0.0f, 1.0f);

	float3 f3Extent = normalize(float3(1.0f, 1.0f, 1.0f));

	
	pf3Positions[0] = position + float3(-f2Size.x, 0.0f, -f2Size.y );
	pf3Positions[1] = position + float3(-f2Size.x, 0.0f, +f2Size.y );
	pf3Positions[2] = position + float3(+f2Size.x, 0.0f, -f2Size.y );
	pf3Positions[3] = position + float3(+f2Size.x, 0.0f, +f2Size.y );
	pf3Positions[4] = position + float3(-f2Size.x, 0.0f, 0.0f);
	pf3Positions[5] = position + float3(+f2Size.x, 0.0f, 0.0f);
	pf3Positions[6] = position + float3(0.0f, 0.0f, +f2Size.y );
	pf3Positions[7] = position + float3(0.0f, 0.0f, -f2Size.y );
	
	
}

[maxvertexcount(9)]
void GSParticleStreamOutput(point VS_PARTICLE_INPUT input[1], inout PointStream<VS_PARTICLE_INPUT> output)
{
	VS_PARTICLE_INPUT particle = input[0];

	particle.age.x += gfElapsedTime;
	
	if (particle.age.x <= particle.age.y)
	{
		if (particle.type == PARTICLE_TYPE_EMITTER)
		{
			particle.color = float3(1.0f, 0.0f, 0.0f);
			//			particle.age.x = 0.0f;

			//output.Append(particle);

			//		float4 f4Random = gRandomBuffer.Load(uint(gfCurrentTime * 1000.0f) % 1000);
			float4 f4Random = gRandomBuffer.Load(int(fmod(gfCurrentTime - floor(gfCurrentTime) * 1000.0f, 1000.0f)));

			float3 pf3Positions[8];
			GetPositions(particle.position, float2(particle.size.x * 5.25f, particle.size.x * 5.25f), pf3Positions);

			particle.color = float3(0.0f, 0.0f, 1.0f);
			particle.age.x = 0.0f;

			for (int j = 0; j < 8; j++)
			{
				particle.position = pf3Positions[j].xyz;
				particle.velocity = float3(0.0f, particle.size.x * particle.age.y * 4.0f, 0.0f) * 2.0f;
				particle.acceleration = float3(0.0f, 250.125f, 0.0f) * abs(f4Random.x);
				particle.age.y = (particle.type == PARTICLE_TYPE_EMITTER) ? 3.25f : 1.5f + (abs(f4Random.w) * 0.75f * abs(j - 4));
				//				particle.age.y = 7.5f;

				particle.type = 1;//(j >= 4) ? PARTICLE_TYPE_EMITTER : PARTICLE_TYPE_FLARE;
				output.Append(particle);
			}
		}
		else
		{
			particle.color = GetParticleColor(particle.age.x, particle.age.y);
			particle.position += (0.5f * particle.acceleration * gfElapsedTime * gfElapsedTime) + (particle.velocity * gfElapsedTime);

			output.Append(particle);
		}
	}
	
	
}

[maxvertexcount(4)]
void GSParticleDraw(point VS_PARTICLE_INPUT input[1], inout TriangleStream<GS_PARTICLE_OUTPUT> outputStream)
{
	//if (input[0].type == PARTICLE_TYPE_EMITTER) return;
	float4 pVertices[4];
	//GetBillboardCorners(input[0].position, input[0].size * 0.5f, pVertices);
	GetBillboardCorners(mul(float4(input[0].position, 1.0f), gmtxWorld).xyz, input[0].size * 1.0f, pVertices);

	GS_PARTICLE_OUTPUT output = (GS_PARTICLE_OUTPUT)0;
	output.color = input[0].color;
	output.age = input[0].age;
	output.type = input[0].type;
	for (int i = 0; i < 4; i++)
	{
		output.position = mul(mul(pVertices[i], gmtxView), gmtxProjection);
		output.uv = gf2QuadUVs[i];

		outputStream.Append(output);
	}
}

float4 PSParticleDraw(GS_PARTICLE_OUTPUT input) : SV_TARGET
{
	float4 cColor = gtxtParticleTexture.Sample(gWrapSamplerState, input.uv);
	//if (input.type == PARTICLE_TYPE_FLARE)
	{
		//		cColor.a *= saturate(0.10f + (1.0f - (input.age.x / input.age.y)));
		//	cColor.rgb *= input.color * (input.age.x / input.age.y);
		//	cColor.rgb = GetParticleColor(gfElapsedTime, gfElapsedTime);
		cColor.rgb *= GetParticleColor(input.age.x, input.age.y);
		//		cColor.rgb = saturate(1.0f - input.age.x);
		//	cColor.rgb = abs(gRandomBuffer.Load(int(fmod(gfCurrentTime, 1000.0f))).rgb);
		//	cColor.rgb = 1.0f;
		//	cColor.b = (input.age.x / input.age.y);
	}

	return(cColor);
}