//------------------------------------------------------- ----------------------
// File: Mesh.h
//-----------------------------------------------------------------------------

#pragma once

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CVertex
{
public:
    XMFLOAT3						m_xmf3Position;	

public:
	CVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); }
	CVertex(XMFLOAT3 xmf3Position) { m_xmf3Position = xmf3Position; }
	~CVertex() { }
};

class CDiffusedVertex : public CVertex
{
public:
    XMFLOAT4						m_xmf4Diffuse;		

public:
	CDiffusedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f); }
	CDiffusedVertex(float x, float y, float z, XMFLOAT4 xmf4Diffuse) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf4Diffuse = xmf4Diffuse; }
	CDiffusedVertex(XMFLOAT3 xmf3Position, XMFLOAT4 xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf4Diffuse = xmf4Diffuse; }
	~CDiffusedVertex() { }
};
class CParticleVertex : public CVertex
{
public:
	XMFLOAT3						m_xmf3Color = XMFLOAT3(0.0f, 0.0f, 0.0f);
	XMFLOAT3						m_xmf3Velocity = XMFLOAT3(0.0f, 0.0f, 0.0f);
	XMFLOAT3						m_xmf3Acceleration = XMFLOAT3(0.0f, 0.0f, 0.0f);
	XMFLOAT2						m_xmf2Size = XMFLOAT2(0.0f, 0.0f);
	XMFLOAT2						m_xmf2AgeLifetime = XMFLOAT2(0.0f, 0.0f); //(Age, Lifetime)
	UINT							m_nType = 0;

public:
	CParticleVertex() { }
	~CParticleVertex() { }
};
class CTexturedVertex : public CVertex
{
public:
	XMFLOAT2						m_xmf2TexCoord;

public:
	CTexturedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf2TexCoord = XMFLOAT2(0.0f, 0.0f); }
	CTexturedVertex(float x, float y, float z, XMFLOAT2 xmf2TexCoord) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf2TexCoord = xmf2TexCoord; }
	CTexturedVertex(XMFLOAT3 xmf3Position, XMFLOAT2 xmf2TexCoord = XMFLOAT2(0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf2TexCoord = xmf2TexCoord; }
	~CTexturedVertex() { }
};

class CDiffusedTexturedVertex : public CDiffusedVertex
{
public:
	XMFLOAT2						m_xmf2TexCoord;

public:
	CDiffusedTexturedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f); m_xmf2TexCoord = XMFLOAT2(0.0f, 0.0f); }
	CDiffusedTexturedVertex(float x, float y, float z, XMFLOAT4 xmf4Diffuse, XMFLOAT2 xmf2TexCoord) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf4Diffuse = xmf4Diffuse; m_xmf2TexCoord = xmf2TexCoord; }
	CDiffusedTexturedVertex(XMFLOAT3 xmf3Position, XMFLOAT4 xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f), XMFLOAT2 xmf2TexCoord = XMFLOAT2(0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf4Diffuse = xmf4Diffuse; m_xmf2TexCoord = xmf2TexCoord; }
	~CDiffusedTexturedVertex() { }
};

class CDiffused2TexturedVertex : public CDiffusedVertex
{
public:
	XMFLOAT2						m_xmf2TexCoord0;
	XMFLOAT2						m_xmf2TexCoord1;

public:
	CDiffused2TexturedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f); m_xmf2TexCoord0 = m_xmf2TexCoord1 = XMFLOAT2(0.0f, 0.0f); }
	CDiffused2TexturedVertex(float x, float y, float z, XMFLOAT4 xmf4Diffuse, XMFLOAT2 xmf2TexCoord0, XMFLOAT2 xmf2TexCoord1) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf4Diffuse = xmf4Diffuse; m_xmf2TexCoord0 = xmf2TexCoord0; m_xmf2TexCoord1 = xmf2TexCoord1; }
	CDiffused2TexturedVertex(XMFLOAT3 xmf3Position, XMFLOAT4 xmf4Diffuse = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f), XMFLOAT2 xmf2TexCoord0 = XMFLOAT2(0.0f, 0.0f), XMFLOAT2 xmf2TexCoord1 = XMFLOAT2(0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf4Diffuse = xmf4Diffuse; m_xmf2TexCoord0 = xmf2TexCoord0; m_xmf2TexCoord1 = xmf2TexCoord1; }
	~CDiffused2TexturedVertex() { }
};
class CIlluminatedVertex : public CVertex
{
protected:
	XMFLOAT3						m_xmf3Normal;

public:
	CIlluminatedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f); }
	CIlluminatedVertex(float x, float y, float z, XMFLOAT3 xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f)) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf3Normal = xmf3Normal; }
	CIlluminatedVertex(XMFLOAT3 xmf3Position, XMFLOAT3 xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf3Normal = xmf3Normal; }
	~CIlluminatedVertex() { }
};

class CIlluminatedTexturedVertex : public CIlluminatedVertex
{
protected:
	XMFLOAT2						m_xmf2TexCoord;

public:
	CIlluminatedTexturedVertex() { m_xmf3Position = XMFLOAT3(0.0f, 0.0f, 0.0f); m_xmf2TexCoord = XMFLOAT2(0.0f, 0.0f); m_xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f); }
	CIlluminatedTexturedVertex(float x, float y, float z, XMFLOAT2 xmf2TexCoord, XMFLOAT3 xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f)) { m_xmf3Position = XMFLOAT3(x, y, z); m_xmf3Normal = xmf3Normal; m_xmf2TexCoord = xmf2TexCoord; }
	CIlluminatedTexturedVertex(XMFLOAT3 xmf3Position, XMFLOAT3 xmf3Normal = XMFLOAT3(0.0f, 0.0f, 0.0f), XMFLOAT2 xmf2TexCoord = XMFLOAT2(0.0f, 0.0f)) { m_xmf3Position = xmf3Position; m_xmf3Normal = xmf3Normal; m_xmf2TexCoord = xmf2TexCoord; }
	~CIlluminatedTexturedVertex() { }
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CMesh
{
public:
    CMesh(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
    virtual ~CMesh();

private:
	int								m_nReferences = 0;

public:
	BoundingOrientedBox			m_xmOOBB;

	BoundingBox						m_xmBoundingBox;
public:
	void AddRef() { m_nReferences++; }
	void Release() { if (--m_nReferences <= 0) delete this; }

	void ReleaseUploadBuffers();

protected:
	ID3D12Resource					*m_pd3dVertexBuffer = NULL;
	ID3D12Resource					*m_pd3dVertexUploadBuffer = NULL;

	ID3D12Resource					*m_pd3dIndexBuffer = NULL;
	ID3D12Resource					*m_pd3dIndexUploadBuffer = NULL;

	D3D12_VERTEX_BUFFER_VIEW		m_d3dVertexBufferView;
	D3D12_INDEX_BUFFER_VIEW			m_d3dIndexBufferView;

	D3D12_PRIMITIVE_TOPOLOGY		m_d3dPrimitiveTopology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	UINT							m_nSlot = 0;
	UINT							m_nVertices = 0;
	UINT							m_nStride = 0;
	UINT							m_nOffset = 0;

	UINT							m_nIndices = 0;
	UINT							m_nStartIndex = 0;
	int								m_nBaseVertex = 0;

public:
	D3D12_VERTEX_BUFFER_VIEW GetVertexBufferView() { return(m_d3dVertexBufferView); }

	virtual void PreRender(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState) { }
	virtual void Render(ID3D12GraphicsCommandList *pd3dCommandList);
	virtual void Render(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState) { }
	virtual void PostRender(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState) { }

	void CalculateBoundingBox(XMFLOAT3* pxmf3Points, UINT nStride);
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CTriangleMeshDiffused : public CMesh
{
public:
    CTriangleMeshDiffused(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
    virtual ~CTriangleMeshDiffused();

	virtual void Render(ID3D12GraphicsCommandList *pd3dCommandList);
};
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CCubeMeshDiffused : public CMesh
{
public:
	CCubeMeshDiffused(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, float fWidth = 2.0f, float fHeight = 2.0f, float fDepth = 2.0f);
	virtual ~CCubeMeshDiffused();
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CCubeMeshTextured : public CMesh
{
public:
	CCubeMeshTextured(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, float fWidth = 2.0f, float fHeight = 2.0f, float fDepth = 2.0f);
	virtual ~CCubeMeshTextured();
};

/////////////////////////////////////////////////////////////////////////////////////////////////
//
class CAirplaneMeshDiffused : public CMesh
{
public:
	CAirplaneMeshDiffused(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, float fWidth = 20.0f, float fHeight = 20.0f, float fDepth = 4.0f, XMFLOAT4 xmf4Color = XMFLOAT4(1.0f, 1.0f, 0.0f, 0.0f));
	virtual ~CAirplaneMeshDiffused();
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CMeshIlluminated : public CMesh
{
public:
	CMeshIlluminated(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList);
	virtual ~CMeshIlluminated();

public:
	void CalculateTriangleListVertexNormals(XMFLOAT3* pxmf3Normals, XMFLOAT3* pxmf3Positions, int nVertices);
	void CalculateTriangleListVertexNormals(XMFLOAT3* pxmf3Normals, XMFLOAT3* pxmf3Positions, UINT nVertices, UINT* pnIndices, UINT nIndices);
	void CalculateTriangleStripVertexNormals(XMFLOAT3* pxmf3Normals, XMFLOAT3* pxmf3Positions, UINT nVertices, UINT* pnIndices, UINT nIndices);
	void CalculateVertexNormals(XMFLOAT3* pxmf3Normals, XMFLOAT3* pxmf3Positions, int nVertices, UINT* pnIndices, int nIndices);
};

class CSphereMeshIlluminated : public CMeshIlluminated
{
public:
	CSphereMeshIlluminated(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, float fRadius = 2.0f, UINT nSlices = 20, UINT nStacks = 20);
	virtual ~CSphereMeshIlluminated();
};
class CCubeMeshIlluminated : public CMeshIlluminated
{
public:
	CCubeMeshIlluminated(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, float fWidth = 2.0f, float fHeight = 2.0f, float fDepth = 2.0f);
	virtual ~CCubeMeshIlluminated();
};

class CPlaneMeshIlluminated : public CMeshIlluminated
{
public:
	CPlaneMeshIlluminated(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, float fWidth = 20.0f, float fHeight = 20.0f, float fDepth = 20.0f, float fxPosition = 0.0f, float fyPosition = 0.0f, float fzPosition = 0.0f);
	virtual ~CPlaneMeshIlluminated();
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CRawFormatImage
{
protected:
	BYTE* m_pRawImagePixels = NULL;

	int							m_nWidth;
	int							m_nLength;

public:
	CRawFormatImage(LPCTSTR pFileName, int nWidth, int nLength, bool bFlipY = false);
	~CRawFormatImage(void);

	BYTE GetRawImagePixel(int x, int z) { return(m_pRawImagePixels[x + (z * m_nWidth)]); }
	void SetRawImagePixel(int x, int z, BYTE nPixel) { m_pRawImagePixels[x + (z * m_nWidth)] = nPixel; }

	BYTE* GetRawImagePixels() { return(m_pRawImagePixels); }

	int GetRawImageWidth() { return(m_nWidth); }
	int GetRawImageLength() { return(m_nLength); }
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//


class CHeightMapImage : public CRawFormatImage
{
public:
	CHeightMapImage(LPCTSTR pFileName, int nWidth, int nLength);
	~CHeightMapImage(void);

	float CHeightMapImage::GetHeight(float fx, float fz, XMFLOAT3 xmf3Scale);
	XMFLOAT3 GetHeightMapNormal(int x, int z, XMFLOAT3 xmf3Scale);
	float GetInterpolatedHeight(int x, int y, float fxFractional, float fzFractional, bool bReverseQuad = false);
};

class CHeightMapGridMesh : public CMesh
{
protected:
	int							m_nWidth;
	int							m_nLength;
	XMFLOAT3					m_xmf3Scale;

public:
	CHeightMapGridMesh(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, int xStart, int zStart, int nWidth, int nLength, XMFLOAT3 xmf3Scale = XMFLOAT3(1.0f, 1.0f, 1.0f), XMFLOAT4 xmf4Color = XMFLOAT4(1.0f, 1.0f, 0.0f, 0.0f), void* pContext = NULL, XMINT2 xmi2ImageScale = XMINT2(1, 1));
	virtual ~CHeightMapGridMesh();

	XMFLOAT3 GetScale() { return(m_xmf3Scale); }

	virtual XMFLOAT4 OnGetColor(int x, int z, void *pContext);
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CTexturedRectMesh : public CMesh
{
public:
	CTexturedRectMesh(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, float fWidth=20.0f, float fHeight=20.0f, float fDepth=20.0f, float fxPosition=0.0f, float fyPosition=0.0f, float fzPosition=0.0f);
	virtual ~CTexturedRectMesh();
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
class CBillboardMesh : public CMesh
{
public:
	CBillboardMesh(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, float fWidth = 20.0f, float fHeight = 20.0f);
	virtual ~CBillboardMesh();
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
#define MAX_PARTICLES					9999
//#define _WITH_QUERY_DATA_SO_STATISTICS

class CParticleMesh : public CMesh
{
public:
	CParticleMesh(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, XMFLOAT3 xmf3Position, XMFLOAT3 xmf3Velocity, XMFLOAT3 xmf3Acceleration, XMFLOAT3 xmf3Color, XMFLOAT2 xmf2Size, float fLifetime, UINT nMaxParticles);
	virtual ~CParticleMesh();

	bool								m_bStart = true;

	UINT								m_nMaxParticles = MAX_PARTICLES;

	ID3D12Resource* m_pd3dStreamOutputBuffer = NULL;
	ID3D12Resource* m_pd3dDrawBuffer = NULL;

	ID3D12Resource* m_pd3dDefaultBufferFilledSize = NULL;
	ID3D12Resource* m_pd3dUploadBufferFilledSize = NULL;
	UINT64* m_pnUploadBufferFilledSize = NULL;
#ifdef _WITH_QUERY_DATA_SO_STATISTICS
	ID3D12QueryHeap* m_pd3dSOQueryHeap = NULL;
	ID3D12Resource* m_pd3dSOQueryBuffer = NULL;
	D3D12_QUERY_DATA_SO_STATISTICS* m_pd3dSOQueryDataStatistics = NULL;
#else
	ID3D12Resource* m_pd3dReadBackBufferFilledSize = NULL;
#endif

	D3D12_STREAM_OUTPUT_BUFFER_VIEW		m_d3dStreamOutputBufferView;

	virtual void CreateVertexBuffer(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, XMFLOAT3 xmf3Position, XMFLOAT3 xmf3Velocity, XMFLOAT3 xmf3Acceleration, XMFLOAT3 xmf3Color, XMFLOAT2 xmf2Size, float fLifetime);
	virtual void CreateStreamOutputBuffer(ID3D12Device* pd3dDevice, ID3D12GraphicsCommandList* pd3dCommandList, UINT nMaxParticles);

	virtual void PreRender(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState);
	virtual void Render(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState);
	virtual void PostRender(ID3D12GraphicsCommandList* pd3dCommandList, int nPipelineState);
};

