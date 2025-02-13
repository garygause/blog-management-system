# Architecture Patterns

## Application Architecture

### Clean Architecture

```typescript
// core/domain/entities/User.ts
export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
}

// core/domain/repositories/UserRepository.ts
export interface UserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// core/usecases/user/CreateUser.ts
export class CreateUserUseCase {
  constructor(private userRepository: UserRepository) {}

  async execute(userData: CreateUserDTO): Promise<User> {
    // Business logic and validation
    const user = await this.userRepository.save(userData);
    return user;
  }
}

// infrastructure/repositories/PostgresUserRepository.ts
export class PostgresUserRepository implements UserRepository {
  async findById(id: string): Promise<User | null> {
    const user = await prisma.user.findUnique({ where: { id } });
    return user ? this.mapToEntity(user) : null;
  }
}
```

### CQRS Pattern

```typescript
// application/commands/CreateUser.ts
export class CreateUserCommand implements Command {
  constructor(public readonly userData: CreateUserDTO) {}
}

// application/queries/GetUserById.ts
export class GetUserByIdQuery implements Query<User> {
  constructor(public readonly id: string) {}
}

// application/handlers/CreateUserHandler.ts
export class CreateUserHandler implements CommandHandler<CreateUserCommand> {
  constructor(private userRepository: UserRepository) {}

  async execute(command: CreateUserCommand): Promise<void> {
    // Command handling logic
  }
}
```

## Frontend Architecture

### Component Architecture

```typescript
// presentation/components/Container.tsx
export const Container: React.FC<ContainerProps> = ({
  children,
  layout = 'stack',
}) => {
  return <StyledContainer layout={layout}>{children}</StyledContainer>;
};

// presentation/templates/PageTemplate.tsx
export const PageTemplate: React.FC<PageTemplateProps> = ({
  header,
  sidebar,
  content,
  footer,
}) => {
  return (
    <Container layout="grid">
      <Header>{header}</Header>
      <Sidebar>{sidebar}</Sidebar>
      <Main>{content}</Main>
      <Footer>{footer}</Footer>
    </Container>
  );
};
```
