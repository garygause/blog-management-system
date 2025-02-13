# Redux Implementation Examples

## Store Configuration

```typescript
// store/index.ts
import { configureStore } from '@reduxjs/toolkit';
import { useDispatch, useSelector, TypedUseSelectorHook } from 'react-redux';
import userReducer from './slices/userSlice';
import authReducer from './slices/authSlice';

export const store = configureStore({
  reducer: {
    user: userReducer,
    auth: authReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Typed hooks
export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

## Slice Example

```typescript
// store/slices/userSlice.ts
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { api } from '../../services/api';

interface User {
  id: string;
  email: string;
  name: string;
}

interface UserState {
  data: User | null;
  loading: boolean;
  error: string | null;
}

const initialState: UserState = {
  data: null,
  loading: false,
  error: null,
};

export const fetchUser = createAsyncThunk(
  'user/fetchUser',
  async (userId: string) => {
    const response = await api.get(`/users/${userId}`);
    return response.data;
  }
);

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    clearUser: (state) => {
      state.data = null;
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUser.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchUser.fulfilled, (state, action) => {
        state.loading = false;
        state.data = action.payload;
      })
      .addCase(fetchUser.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch user';
      });
  },
});

export const { clearUser } = userSlice.actions;
export default userSlice.reducer;
```

## Usage Example

```typescript
// components/UserProfile.tsx
import React, { useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../store';
import { fetchUser } from '../store/slices/userSlice';

export const UserProfile: React.FC = () => {
  const dispatch = useAppDispatch();
  const { data: user, loading, error } = useAppSelector((state) => state.user);

  useEffect(() => {
    dispatch(fetchUser('123'));
  }, [dispatch]);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!user) return <div>No user found</div>;

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
};
```
