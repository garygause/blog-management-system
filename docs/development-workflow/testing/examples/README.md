# Testing Examples

## Unit Testing Components

### Button Component Test

```typescript
// Button.test.tsx
import { render, fireEvent } from '@testing-library/react';
import { Button } from './Button';
import { ThemeProvider } from 'styled-components';
import { theme } from '../theme';

describe('Button Component', () => {
  const renderButton = (props = {}) => {
    return render(
      <ThemeProvider theme={theme}>
        <Button {...props}>Click me</Button>
      </ThemeProvider>
    );
  };

  it('renders correctly', () => {
    const { getByText } = renderButton({ variant: 'primary', size: 'medium' });
    expect(getByText('Click me')).toBeInTheDocument();
  });

  it('handles click events', () => {
    const onClick = jest.fn();
    const { getByText } = renderButton({
      onClick,
      variant: 'primary',
      size: 'medium',
    });

    fireEvent.click(getByText('Click me'));
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it('respects disabled state', () => {
    const onClick = jest.fn();
    const { getByText } = renderButton({
      disabled: true,
      onClick,
      variant: 'primary',
      size: 'medium',
    });

    fireEvent.click(getByText('Click me'));
    expect(onClick).not.toHaveBeenCalled();
  });
});
```

## Integration Testing

### API Integration Test

```typescript
// userApi.test.ts
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import { fetchUser } from '../store/slices/userSlice';
import { store } from '../store';

const server = setupServer(
  rest.get('/api/users/:id', (req, res, ctx) => {
    return res(
      ctx.json({
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
      })
    );
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('User API Integration', () => {
  it('fetches user successfully', async () => {
    await store.dispatch(fetchUser('123'));
    const state = store.getState().user;

    expect(state.loading).toBe(false);
    expect(state.data).toEqual({
      id: '123',
      name: 'John Doe',
      email: 'john@example.com',
    });
  });

  it('handles error states', async () => {
    server.use(
      rest.get('/api/users/:id', (req, res, ctx) => {
        return res(ctx.status(500));
      })
    );

    await store.dispatch(fetchUser('123'));
    const state = store.getState().user;

    expect(state.loading).toBe(false);
    expect(state.error).toBeTruthy();
  });
});
```

## E2E Testing

### User Flow Test

```typescript
// cypress/integration/user-flow.spec.ts
describe('User Authentication Flow', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('successfully logs in and views profile', () => {
    // Login
    cy.get('[data-testid="email-input"]').type('user@example.com');
    cy.get('[data-testid="password-input"]').type('password123');
    cy.get('[data-testid="login-button"]').click();

    // Verify redirect to dashboard
    cy.url().should('include', '/dashboard');

    // Navigate to profile
    cy.get('[data-testid="profile-link"]').click();
    cy.url().should('include', '/profile');

    // Verify profile data
    cy.get('[data-testid="user-name"]').should('contain', 'John Doe');
    cy.get('[data-testid="user-email"]').should('contain', 'user@example.com');
  });

  it('handles invalid login attempts', () => {
    cy.get('[data-testid="email-input"]').type('invalid@example.com');
    cy.get('[data-testid="password-input"]').type('wrongpassword');
    cy.get('[data-testid="login-button"]').click();

    cy.get('[data-testid="error-message"]')
      .should('be.visible')
      .and('contain', 'Invalid credentials');
  });
});
```

## Performance Testing

### API Load Test

```typescript
// k6/api-load.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 }, // Ramp up
    { duration: '1m', target: 20 }, // Stay at peak
    { duration: '30s', target: 0 }, // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests must complete below 500ms
    http_req_failed: ['rate<0.01'], // Less than 1% can fail
  },
};

export default function () {
  const response = http.get('http://api.example.com/users');

  check(response, {
    'is status 200': (r) => r.status === 200,
    'response time OK': (r) => r.timings.duration < 500,
  });

  sleep(1);
}
```
