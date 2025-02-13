# API Endpoints Documentation

## Authentication

### POST /api/auth/token

Generate authentication token

Request:

```json
{
  "username": "string",
  "password": "string"
}
```

Response:

```json
{
  "access_token": "string",
  "token_type": "bearer"
}
```

## Blog Posts

### POST /api/posts

Create new blog post

Request:

```json
{
  "topic": "string",
  "keywords": ["string"],
  "target_length": "integer",
  "tone": "string"
}
```

Response:

```json
{
  "id": "string",
  "status": "draft",
  "content": "string",
  "metadata": {
    "seo_score": "number",
    "readability_score": "number"
  }
}
```

### GET /api/posts/{post_id}

Get blog post details

Response:

```json
{
  "id": "string",
  "topic": "string",
  "content": "string",
  "status": "string",
  "created_at": "string",
  "updated_at": "string",
  "seo_metrics": {
    "score": "number",
    "suggestions": ["string"]
  }
}
```

## SEO Analysis

### POST /api/seo/analyze

Analyze content for SEO

Request:

```json
{
  "content": "string",
  "keywords": ["string"]
}
```

Response:

```json
{
  "score": "number",
  "suggestions": ["string"],
  "keyword_density": {
    "keyword": "frequency"
  }
}
```

## Publishing

### POST /api/publish

Publish content to platform

Request:

```json
{
  "post_id": "string",
  "platform": "string",
  "schedule_time": "string",
  "custom_options": {}
}
```

Response:

```json
{
  "status": "scheduled",
  "platform_url": "string",
  "scheduled_time": "string"
}
```

## Analytics

### GET /api/analytics/posts/{post_id}

Get post performance metrics

Response:

```json
{
  "views": "integer",
  "engagement_rate": "number",
  "social_shares": "integer",
  "conversion_rate": "number",
  "timeline": [
    {
      "date": "string",
      "metrics": {
        "views": "integer",
        "shares": "integer"
      }
    }
  ]
}
```

## FastAPI Implementation

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List

app = FastAPI(
    title="Blog Management API",
    description="API for AI-powered blog content management",
    version="1.0.0"
)

class PostCreate(BaseModel):
    topic: str
    keywords: List[str]
    target_length: int = 1000
    tone: str = "professional"

@app.post("/api/posts", response_model=Post)
async def create_post(post: PostCreate):
    """
    Create a new blog post using AI generation
    """
    try:
        # Generate content using LangChain
        content = await content_generation_agent.generate(
            topic=post.topic,
            keywords=post.keywords
        )

        # Analyze SEO
        seo_results = await seo_analysis_agent.analyze(content)

        return {
            "id": generate_id(),
            "content": content,
            "seo_metrics": seo_results
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```
