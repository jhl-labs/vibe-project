/**
 * User Entity
 *
 * 사용자 도메인 엔터티입니다.
 * 비즈니스 규칙과 불변성을 캡슐화합니다.
 */

export type UserStatus = 'active' | 'inactive' | 'suspended';

export interface UserProps {
  id: string;
  email: string;
  name: string;
  status: UserStatus;
  createdAt: Date;
  updatedAt: Date;
}

export class User {
  private constructor(private readonly props: UserProps) {}

  get id(): string {
    return this.props.id;
  }

  get email(): string {
    return this.props.email;
  }

  get name(): string {
    return this.props.name;
  }

  get status(): UserStatus {
    return this.props.status;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  get isActive(): boolean {
    return this.props.status === 'active';
  }

  /**
   * 새 사용자 생성
   */
  static create(props: Omit<UserProps, 'status' | 'createdAt' | 'updatedAt'>): User {
    return new User({
      ...props,
      status: 'active',
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  }

  /**
   * DB에서 복원
   */
  static fromPersistence(props: UserProps): User {
    return new User(props);
  }

  /**
   * 사용자 정보 업데이트
   */
  update(data: Partial<Pick<UserProps, 'name' | 'email'>>): User {
    return new User({
      ...this.props,
      ...data,
      updatedAt: new Date(),
    });
  }

  /**
   * 사용자 비활성화
   */
  deactivate(): User {
    if (this.props.status === 'inactive') {
      throw new Error('User is already inactive');
    }
    return new User({
      ...this.props,
      status: 'inactive',
      updatedAt: new Date(),
    });
  }

  /**
   * 사용자 활성화
   */
  activate(): User {
    if (this.props.status === 'active') {
      throw new Error('User is already active');
    }
    return new User({
      ...this.props,
      status: 'active',
      updatedAt: new Date(),
    });
  }

  /**
   * 직렬화
   */
  toJSON(): UserProps {
    return { ...this.props };
  }
}
