# Component Examples

## Basic Components

### Button Component

```tsx
// Button.tsx
import styled from 'styled-components';

interface ButtonProps {
  variant: 'primary' | 'secondary' | 'danger';
  size: 'small' | 'medium' | 'large';
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

const StyledButton = styled.button<ButtonProps>`
  padding: ${(props) => (props.size === 'small' ? '8px 16px' : '12px 24px')};
  border-radius: 4px;
  border: none;
  font-weight: 600;
  cursor: ${(props) => (props.disabled ? 'not-allowed' : 'pointer')};
  opacity: ${(props) => (props.disabled ? 0.6 : 1)};

  ${(props) => {
    switch (props.variant) {
      case 'primary':
        return `
          background: ${props.theme.colors.primary};
          color: white;
        `;
      case 'secondary':
        return `
          background: transparent;
          border: 1px solid ${props.theme.colors.primary};
          color: ${props.theme.colors.primary};
        `;
      case 'danger':
        return `
          background: ${props.theme.colors.error};
          color: white;
        `;
    }
  }}
`;

export const Button: React.FC<ButtonProps> = ({
  variant,
  size,
  disabled,
  onClick,
  children,
}) => (
  <StyledButton
    variant={variant}
    size={size}
    disabled={disabled}
    onClick={onClick}
  >
    {children}
  </StyledButton>
);
```

### Form Input Component

```tsx
// Input.tsx
import styled from 'styled-components';

interface InputProps {
  type?: 'text' | 'email' | 'password';
  label: string;
  error?: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

const InputWrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 4px;
`;

const Label = styled.label`
  font-size: 14px;
  font-weight: 500;
  color: ${(props) => props.theme.colors.text};
`;

const StyledInput = styled.input<{ hasError?: boolean }>`
  padding: 8px 12px;
  border-radius: 4px;
  border: 1px solid ${(props) =>
      props.hasError ? props.theme.colors.error : props.theme.colors.border};
  font-size: 16px;

  &:focus {
    outline: none;
    border-color: ${(props) => props.theme.colors.primary};
  }
`;

const ErrorText = styled.span`
  font-size: 12px;
  color: ${(props) => props.theme.colors.error};
`;

export const Input: React.FC<InputProps> = ({
  type = 'text',
  label,
  error,
  value,
  onChange,
}) => (
  <InputWrapper>
    <Label>{label}</Label>
    <StyledInput
      type={type}
      value={value}
      onChange={onChange}
      hasError={!!error}
    />
    {error && <ErrorText>{error}</ErrorText>}
  </InputWrapper>
);
```
