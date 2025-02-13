# AI Implementation Guide

## Current Standards & Best Practices

### 1. Agent Architecture

- Use LangGraph for complex workflows instead of traditional LangChain agents
- Implement LCEL (LangChain Expression Language) for chain composition
- Use Pydantic v2 models for type safety and validation
- Implement async patterns for better performance

### 2. Recommended Updates to Current Implementation

```python
# agents/base.py
from typing import List, Dict, Any
from langchain_core.agents import AgentAction, AgentFinish
from langchain_core.tools import BaseTool
from langchain_core.pydantic_v1 import BaseModel, Field
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import PydanticOutputParser

class BaseAgent(BaseModel):
    """Base class for all agents with common functionality"""
    tools: List[BaseTool]
    llm: Any = Field(description="Language model to use")

    class Config:
        arbitrary_types_allowed = True

    async def aplan(self, state: Dict[str, Any]) -> AgentAction | AgentFinish:
        """Async planning method required by LangGraph"""
        raise NotImplementedError()
```

### 3. Content Generation Agent Updates

```python
# agents/content_generation.py
from langchain_community.tools import DuckDuckGoSearchResults
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage

class BlogContent(BaseModel):
    """Pydantic model for blog content with validation"""
    title: str = Field(..., description="Title of the blog post")
    content: str = Field(..., description="Main content of the blog post")
    sections: List[str] = Field(..., description="Main sections of the blog post")
    keywords_used: List[str] = Field(..., description="Keywords used in the content")

class ContentGenerationAgent(BaseAgent):
    def __init__(self):
        super().__init__(
            tools=[DuckDuckGoSearchResults()],
            llm=ChatOpenAI(model="gpt-4-turbo-preview", temperature=0.7)
        )
        self.output_parser = PydanticOutputParser(pydantic_object=BlogContent)

    def get_prompt(self) -> ChatPromptTemplate:
        return ChatPromptTemplate.from_messages([
            SystemMessage(content="You are a professional blog writer..."),
            HumanMessage(content="{input}")
        ])

    async def aplan(self, state: Dict[str, Any]) -> AgentAction | AgentFinish:
        # Implementation using LangGraph patterns
```

### 4. LangGraph Integration Best Practices

```python
# workflows/blog_workflow.py
from langgraph.graph import Graph, StateGraph
from typing import TypedDict, Annotated

# Define state schema
class WorkflowState(TypedDict):
    topic: str
    keywords: List[str]
    content: Optional[str]
    seo_score: Optional[float]
    published_url: Optional[str]

def create_workflow() -> StateGraph:
    # Create a state graph instead of basic graph
    workflow = StateGraph(WorkflowState)

    # Add nodes with type checking
    workflow.add_node("content_generation", ContentGenerationAgent())
    workflow.add_node("seo_analysis", SEOAnalysisAgent())

    # Add edges with conditions
    workflow.add_edge(
        "content_generation",
        "seo_analysis",
        condition=lambda state: state.get("content") is not None
    )

    return workflow
```

### 5. Testing Standards

```python
# tests/test_agents.py
import pytest
from langchain_core.agents import AgentAction
from unittest.mock import Mock

@pytest.mark.asyncio
async def test_content_generation_agent():
    agent = ContentGenerationAgent()
    state = {
        "topic": "AI Testing",
        "keywords": ["pytest", "automation"]
    }

    result = await agent.aplan(state)
    assert isinstance(result, (AgentAction, AgentFinish))
```

## Implementation Checklist

1. Agent Structure:

   - [ ] Use LCEL for chain composition
   - [ ] Implement async methods
   - [ ] Use type hints consistently
   - [ ] Implement proper error handling

2. State Management:

   - [ ] Use TypedDict for state definitions
   - [ ] Implement state validation
   - [ ] Handle state transitions properly
   - [ ] Include proper error states

3. Monitoring:

   - [ ] Integrate LangSmith for debugging
   - [ ] Implement proper logging
   - [ ] Add metrics collection
   - [ ] Set up tracing

4. Testing:
   - [ ] Unit tests for each agent
   - [ ] Integration tests for workflows
   - [ ] Mock external services
   - [ ] Test error conditions

## Common Pitfalls to Avoid

1. Chain Composition:

   ```python
   # Bad
   result = chain1(chain2(input))

   # Good
   chain = chain1 | chain2
   result = chain.invoke(input)
   ```

2. Error Handling:

   ```python
   # Bad
   try:
       result = await agent.aplan(state)
   except Exception as e:
       print(f"Error: {e}")

   # Good
   try:
       result = await agent.aplan(state)
   except AgentError as e:
       logger.error("Agent execution failed", exc_info=e)
       raise
   ```

3. State Management:

   ```python
   # Bad
   state["content"] = generate_content()

   # Good
   state = {**state, "content": generate_content()}
   ```

## Migration Guide

1. Update Dependencies:

   ```bash
   pip install -U langchain-core langchain-community langchain-openai langgraph
   ```

2. Update Imports:

   ```python
   # Old
   from langchain.agents import Tool
   from langchain.chat_models import ChatOpenAI

   # New
   from langchain_core.tools import BaseTool
   from langchain_openai import ChatOpenAI
   ```

3. Update Chain Composition:

   ```python
   # Old
   chain = LLMChain(llm=llm, prompt=prompt)

   # New
   chain = prompt | llm | output_parser
   ```
