# AI Agents Documentation

## Agent Architecture Overview

Each agent is implemented using LangChain's Expression Language (LCEL) and orchestrated through LangGraph for complex workflows.

### Content Generation Agent

- Purpose: Creates blog content from topics and keywords
- Components:
  - Topic Analysis
  - Content Research
  - Content Generation
  - Content Refinement

```python
# agents/content_generation.py
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import PydanticOutputParser
from langchain.chat_models import ChatOpenAI
from langchain.tools import DuckDuckGoSearchResults
from pydantic import BaseModel

class BlogContent(BaseModel):
    title: str
    content: str
    sections: List[str]
    keywords_used: List[str]

class ContentGenerationAgent:
    def __init__(self):
        self.search_tool = DuckDuckGoSearchResults()
        self.llm = ChatOpenAI(model="gpt-4-turbo-preview")
        self.output_parser = PydanticOutputParser(pydantic_object=BlogContent)

    def research_chain(self):
        return (
            ChatPromptTemplate.from_messages([
                ("system", "You are a research expert. Find relevant information about: {topic}"),
                ("user", "{context}")
            ])
            | self.llm
            | self.search_tool
        )

    def content_chain(self):
        return (
            ChatPromptTemplate.from_messages([
                ("system", BLOG_WRITER_PROMPT),
                ("user", "Topic: {topic}\nKeywords: {keywords}\nResearch: {research}")
            ])
            | self.llm
            | self.output_parser
        )

    async def generate(self, topic: str, keywords: List[str]) -> BlogContent:
        research = await self.research_chain().ainvoke({
            "topic": topic,
            "context": f"Find information about {topic} focusing on {', '.join(keywords)}"
        })

        return await self.content_chain().ainvoke({
            "topic": topic,
            "keywords": keywords,
            "research": research
        })
```

### SEO Analysis Agent

- Purpose: Optimizes content for search engines
- Components:
  - Keyword Analysis
  - Content Scoring
  - Optimization Suggestions
  - Meta Data Generation

```python
# agents/seo_analysis.py
from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import SequentialChain
from langchain.tools import SEOAnalysisTool

class SEOAnalysisAgent:
    def __init__(self):
        self.seo_tool = SEOAnalysisTool()
        self.llm = ChatOpenAI(model="gpt-4-turbo-preview")

    def keyword_analysis_chain(self):
        return (
            ChatPromptTemplate.from_messages([
                ("system", SEO_EXPERT_PROMPT),
                ("user", "Analyze keyword usage in:\n{content}")
            ])
            | self.llm
            | self.seo_tool.analyze_keywords
        )

    def optimization_chain(self):
        return (
            ChatPromptTemplate.from_messages([
                ("system", "Based on the SEO analysis, suggest improvements"),
                ("user", "Content: {content}\nAnalysis: {analysis}")
            ])
            | self.llm
            | PydanticOutputParser(pydantic_object=SEOSuggestions)
        )

    async def analyze(self, content: str) -> SEOAnalysis:
        keyword_analysis = await self.keyword_analysis_chain().ainvoke({
            "content": content
        })

        return await self.optimization_chain().ainvoke({
            "content": content,
            "analysis": keyword_analysis
        })
```

### Publishing Agent

- Purpose: Handles content publishing workflow
- Components:
  - Platform Integration
  - Format Conversion
  - Schedule Management
  - Distribution

```python
# agents/publishing.py
from langchain.agents import AgentExecutor
from langchain.tools import WordPressTool, MediumTool

class PublishingAgent:
    def __init__(self):
        self.platforms = {
            "wordpress": WordPressTool(),
            "medium": MediumTool()
        }
        self.llm = ChatOpenAI(model="gpt-4-turbo-preview")

    def format_chain(self, platform: str):
        return (
            ChatPromptTemplate.from_messages([
                ("system", f"Format content for {platform}"),
                ("user", "{content}")
            ])
            | self.llm
            | self.platforms[platform].format_content
        )

    async def publish(self, content: str, platform: str) -> PublishResult:
        formatted_content = await self.format_chain(platform).ainvoke({
            "content": content
        })

        return await self.platforms[platform].publish(formatted_content)
```

### Performance Monitoring Agent

- Purpose: Tracks content performance
- Components:
  - Analytics Integration
  - Performance Metrics
  - Engagement Tracking
  - Report Generation

```python
# agents/monitoring.py
from langchain.tools import GoogleAnalyticsTool
from langchain.agents import create_react_agent

class MonitoringAgent:
    def __init__(self):
        self.analytics_tool = GoogleAnalyticsTool()
        self.llm = ChatOpenAI(model="gpt-4-turbo-preview")

    def metrics_chain(self):
        return create_react_agent(
            llm=self.llm,
            tools=[self.analytics_tool],
            prompt=MONITORING_PROMPT
        )

    async def generate_report(self, post_id: str) -> PerformanceReport:
        metrics = await self.analytics_tool.get_metrics(post_id)

        return await self.metrics_chain().ainvoke({
            "metrics": metrics,
            "post_id": post_id
        })
```

## LangGraph Workflow Integration

```python
# workflows/blog_creation.py
from langgraph.graph import Graph, Node
from typing import Dict, Any

def create_blog_workflow() -> Graph:
    # Create nodes for each agent
    content_node = Node(ContentGenerationAgent(), name="content_generation")
    seo_node = Node(SEOAnalysisAgent(), name="seo_analysis")
    publish_node = Node(PublishingAgent(), name="publishing")
    monitor_node = Node(MonitoringAgent(), name="monitoring")

    # Create the graph
    workflow = Graph()

    # Add nodes
    workflow.add_node(content_node)
    workflow.add_node(seo_node)
    workflow.add_node(publish_node)
    workflow.add_node(monitor_node)

    # Define edges
    workflow.add_edge(content_node, seo_node)
    workflow.add_edge(seo_node, publish_node)
    workflow.add_edge(publish_node, monitor_node)

    return workflow

async def execute_workflow(topic: str, keywords: List[str]) -> Dict[str, Any]:
    workflow = create_blog_workflow()

    result = await workflow.ainvoke({
        "topic": topic,
        "keywords": keywords
    })

    return result
```

## LangSmith Monitoring

```python
# monitoring/langsmith_integration.py
from langsmith import Client
from contextlib import contextmanager

@contextmanager
def track_agent_execution(agent_name: str, **kwargs):
    client = Client()

    with client.track_run(
        project_name="blog_generation",
        run_type="chain",
        name=f"{agent_name}_execution",
        **kwargs
    ) as run:
        try:
            yield run
        except Exception as e:
            run.track_error(e)
            raise
```
