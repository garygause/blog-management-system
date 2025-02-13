# Styling Guidelines

## Design System

Our design system follows these core principles:

### Color Palette

Primary Colors:

- Primary: #0066CC
- Secondary: #4A90E2
- Accent: #FF6B6B

Neutral Colors:

- Background: #FFFFFF
- Text: #333333
- Border: #E5E5E5

Status Colors:

- Success: #28A745
- Error: #DC3545
- Warning: #FFC107
- Info: #17A2B8

### Typography

Font Families:

- Primary: Inter
- Secondary: Roboto
- Monospace: Source Code Pro

Font Sizes:

- xs: 12px
- sm: 14px
- base: 16px
- lg: 18px
- xl: 20px
- 2xl: 24px
- 3xl: 30px
- 4xl: 36px

### Spacing System

We use an 8-point grid system:

- 2xs: 4px
- xs: 8px
- sm: 16px
- md: 24px
- lg: 32px
- xl: 40px
- 2xl: 48px

### Component Styling

1. Base Components:

   - Use styled-components
   - Follow atomic design
   - Maintain consistency

2. Layout Components:

   - Flexible grid system
   - Responsive containers
   - Consistent spacing

3. Theme Integration:
   - Use theme context
   - Support dark mode
   - Handle RTL

## Best Practices

1. Component Structure:

   - Separate styling logic
   - Use styled-components
   - Maintain prop types

2. Responsive Design:

   - Mobile-first approach
   - Breakpoint consistency
   - Flexible layouts

3. Performance:
   - Minimize CSS-in-JS
   - Use memoization
   - Optimize renders

## Accessibility

1. Color Contrast:

   - WCAG 2.1 compliance
   - Sufficient contrast ratios
   - Alternative themes

2. Typography:

   - Readable font sizes
   - Line height guidelines
   - Font scaling support

3. Interactive Elements:
   - Focus states
   - Hover states
   - Active states

## CSS Architecture

1. Naming Conventions:

   - BEM methodology
   - Semantic names
   - Consistent patterns

2. File Organization:

   - Component-specific styles
   - Shared utilities
   - Theme definitions

3. Global Styles:
   - Reset/Normalize
   - Base styles
   - Typography rules
