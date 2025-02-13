# Frontend Routes Documentation

## Next.js App Router Structure

```typescript
// app directory structure
app/
├── (auth)/
│   ├── login/
│   │   └── page.tsx
│   ├── register/
│   │   └── page.tsx
│   └── layout.tsx
├── dashboard/
│   ├── page.tsx
│   └── layout.tsx
├── posts/
│   ├── [id]/
│   │   ├── page.tsx
│   │   └── edit/
│   │       └── page.tsx
│   ├── new/
│   │   └── page.tsx
│   └── page.tsx
├── analytics/
│   ├── [id]/
│   │   └── page.tsx
│   └── page.tsx
└── layout.tsx
```

## Page Routes

### Authentication Routes

- `app/(auth)/login/page.tsx` - User login

  - Email/password login
  - OAuth providers
  - Session management

- `app/(auth)/register/page.tsx` - User registration
  - Account creation
  - Initial setup

### Dashboard Routes

- `app/dashboard/page.tsx` - Main dashboard

  ```typescript
  // app/dashboard/page.tsx
  export default async function DashboardPage() {
    const posts = await fetchPosts();
    const analytics = await fetchAnalytics();

    return (
      <DashboardLayout>
        <PerformanceOverview data={analytics} />
        <RecentPosts posts={posts} />
        <AIInsights />
      </DashboardLayout>
    );
  }
  ```

### Blog Management Routes

- `app/posts/page.tsx` - Posts listing

  ```typescript
  // app/posts/page.tsx
  export default async function PostsPage({
    searchParams,
  }: {
    searchParams: { status?: string; sort?: string };
  }) {
    const posts = await fetchPosts(searchParams);

    return (
      <PostsLayout>
        <PostFilters />
        <PostsList posts={posts} />
        <Pagination />
      </PostsLayout>
    );
  }
  ```

- `app/posts/new/page.tsx` - Create post
  ```typescript
  // app/posts/new/page.tsx
  export default function NewPostPage() {
    return (
      <PostEditor>
        <AIGenerationControls />
        <SEOAnalyzer />
        <PublishingOptions />
      </PostEditor>
    );
  }
  ```

### API Routes

- `app/api/posts/route.ts` - Posts API handlers

  ```typescript
  // app/api/posts/route.ts
  import { NextResponse } from 'next/server';

  export async function POST(request: Request) {
    const data = await request.json();

    // Call FastAPI backend
    const response = await fetch(`${process.env.API_URL}/posts`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    const result = await response.json();
    return NextResponse.json(result);
  }
  ```

## Route Protection

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');

  if (!token && !request.nextUrl.pathname.startsWith('/auth')) {
    return NextResponse.redirect(new URL('/auth/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/posts/:path*', '/analytics/:path*'],
};
```

## API Integration

```typescript
// lib/api.ts
export async function fetchPosts(params: PostQueryParams) {
  const queryString = new URLSearchParams(params).toString();
  const response = await fetch(
    `${process.env.NEXT_PUBLIC_API_URL}/posts?${queryString}`,
    {
      headers: {
        Authorization: `Bearer ${getToken()}`,
      },
    }
  );

  if (!response.ok) {
    throw new Error('Failed to fetch posts');
  }

  return response.json();
}
```
