# Page Layouts Documentation

## Layout Structure

### Root Layout

```typescript
// app/layout.tsx
import { Inter } from 'next/font/google';
import { Providers } from '@/components/providers';

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### Dashboard Layout

```typescript
// app/dashboard/layout.tsx
import { Sidebar } from '@/components/navigation/Sidebar';
import { Header } from '@/components/navigation/Header';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      <div className="flex">
        <Sidebar />
        <main className="flex-1 p-6">{children}</main>
      </div>
    </div>
  );
}
```

## Page Components

### Blog Post Editor

```typescript
// components/posts/PostEditor.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

interface PostEditorProps {
  initialContent?: string;
}

export function PostEditor({ initialContent = '' }: PostEditorProps) {
  const router = useRouter();
  const [content, setContent] = useState(initialContent);
  const [isGenerating, setIsGenerating] = useState(false);

  const handleAIGenerate = async () => {
    setIsGenerating(true);
    try {
      const response = await fetch('/api/generate-content', {
        method: 'POST',
        body: JSON.stringify({ prompt: content }),
      });
      const generated = await response.json();
      setContent(generated.content);
    } finally {
      setIsGenerating(false);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between">
        <Button onClick={handleAIGenerate} isLoading={isGenerating}>
          Generate with AI
        </Button>
        <Button onClick={handleSave}>Save</Button>
      </div>
      <Editor value={content} onChange={setContent} />
      <SEOAnalysis content={content} />
    </div>
  );
}
```

### Analytics Dashboard

```typescript
// components/analytics/AnalyticsDashboard.tsx
'use client';

import { useQuery } from '@tanstack/react-query';
import { fetchAnalytics } from '@/lib/api';

interface AnalyticsProps {
  postId?: string;
  timeframe: 'day' | 'week' | 'month';
}

export function AnalyticsDashboard({ postId, timeframe }: AnalyticsProps) {
  const { data, isLoading } = useQuery({
    queryKey: ['analytics', postId, timeframe],
    queryFn: () => fetchAnalytics(postId, timeframe),
  });

  if (isLoading) return <Loading />;

  return (
    <div className="space-y-6">
      <MetricsOverview data={data.overview} />
      <PerformanceGraph data={data.performance} />
      <TopPosts data={data.topPosts} />
    </div>
  );
}
```

## Server Components

### Posts List

```typescript
// app/posts/PostsList.tsx
import { fetchPosts } from '@/lib/api';

export async function PostsList() {
  const posts = await fetchPosts();

  return (
    <div className="grid gap-4">
      {posts.map((post) => (
        <PostCard key={post.id} post={post} />
      ))}
    </div>
  );
}
```

### SEO Analyzer

```typescript
// components/seo/SEOAnalyzer.tsx
'use client';

import { useMutation } from '@tanstack/react-query';
import { analyzeSEO } from '@/lib/api';

export function SEOAnalyzer({ content }: { content: string }) {
  const { mutate, data } = useMutation({
    mutationFn: analyzeSEO,
  });

  return (
    <div className="rounded-lg border p-4">
      <h3 className="text-lg font-medium">SEO Analysis</h3>
      <Button onClick={() => mutate({ content })}>Analyze Content</Button>
      {data && <SEOResults results={data} />}
    </div>
  );
}
```

## Content Requirements

### Dashboard Page

Required Sections:

1. Performance Overview

   - Total views
   - Engagement rate
   - Top performing posts

2. Recent Activity

   - Latest posts
   - Recent analytics
   - Scheduled publications

3. Quick Actions
   - Create new post
   - Run SEO analysis
   - View analytics

### Blog Post Creation

Required Sections:

1. Topic Input

   - Title field
   - Keywords input
   - Target audience selection

2. Content Generation

   - AI generation controls
   - Editor interface
   - Format options

3. SEO Analysis
   - Real-time scoring
   - Keyword density
   - Improvement suggestions

### Analytics View

Required Sections:

1. Metrics Dashboard

   - Traffic overview
   - Engagement metrics
   - Conversion data

2. Content Performance

   - Post rankings
   - Historical trends
   - Platform comparison

3. Export Options
   - Data download
   - Report generation
   - Custom date ranges
