# Component Documentation

This section details our component architecture and usage guidelines.

## Component Structure

Components are organized into the following categories:

1. **Atoms** - Basic building blocks (buttons, inputs, icons)
2. **Molecules** - Combinations of atoms (form fields, search bars)
3. **Organisms** - Complex components (headers, sidebars, forms)
4. **Templates** - Page layouts
5. **Pages** - Complete page components

## Component Guidelines

### File Structure

Each component should follow this structure:

```tsx
/ComponentName
├── index.tsx
├── ComponentName.tsx
├── ComponentName.styles.ts
├── ComponentName.test.tsx
└── ComponentName.stories.tsx
```

### Component Example

```tsx
// Button.tsx
import React from 'react';
import { StyledButton } from './Button.styles';
interface ButtonProps {
  variant: 'primary' | 'secondary';
  size: 'small' | 'medium' | 'large';
  children: React.ReactNode;
  onClick?: () => void;
}
export const Button: React.FC<ButtonProps> = ({
  variant,
  size,
  children,
  onClick,
}) => {
  return (
    <StyledButton variant={variant} size={size} onClick={onClick}>
      {children}
    </StyledButton>
  );
};
```

### Best Practices

1. Use TypeScript for all components
2. Write comprehensive tests
3. Include Storybook stories
4. Document props using JSDoc comments
5. Keep components focused and single-responsibility
