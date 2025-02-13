# State Management

This guide covers our state management patterns and best practices.

## Overview

We use a combination of state management solutions:

- Redux for global application state
- Context API for theme and authentication
- Local state for component-specific data

## Redux Structure

```
store/
├── actions/
├── reducers/
├── selectors/
├── types/
└── index.ts
```

### Action Creation

```typescript
// actions/userActions.ts
export const setUser = (user: User) => ({
  type: 'SET_USER',
  payload: user,
});
```

### Using Selectors

```typescript
// selectors/userSelectors.ts
export const selectUser = (state: RootState) => state.user;
```

## Context API Usage

```typescript
// context/ThemeContext.ts
export const ThemeContext = createContext<ThemeContextType>({
  theme: 'light',
  toggleTheme: () => {},
});
```

## State Management Guidelines

1. Use Redux for:

   - Global application state
   - Shared data between components
   - Complex state updates

2. Use Context for:

   - Theme
   - Authentication
   - Localization

3. Use Local State for:
   - Form inputs
   - UI state
   - Component-specific data
