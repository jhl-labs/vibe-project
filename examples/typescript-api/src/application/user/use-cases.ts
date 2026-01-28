import { User } from '../../domain/user/entity';
import { IUserRepository } from '../../domain/user/repository';
import {
  UserNotFoundError,
  UserAlreadyExistsError,
} from '../../domain/user/errors';
import {
  CreateUserInput,
  UpdateUserInput,
  UserResponse,
  ListUsersQuery,
  ListUsersResponse,
} from './dto';
import { randomUUID } from 'crypto';

/**
 * User Use Cases
 *
 * 애플리케이션 비즈니스 로직을 담당합니다.
 */
export class UserUseCases {
  constructor(private readonly userRepository: IUserRepository) {}

  /**
   * 사용자 생성
   */
  async createUser(input: CreateUserInput): Promise<UserResponse> {
    // 이메일 중복 확인
    const existing = await this.userRepository.findByEmail(input.email);
    if (existing) {
      throw new UserAlreadyExistsError(input.email);
    }

    // 사용자 생성
    const user = User.create({
      id: randomUUID(),
      email: input.email,
      name: input.name,
    });

    // 저장
    const saved = await this.userRepository.save(user);

    return this.toResponse(saved);
  }

  /**
   * 사용자 조회
   */
  async getUser(id: string): Promise<UserResponse> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new UserNotFoundError(id);
    }

    return this.toResponse(user);
  }

  /**
   * 사용자 목록 조회
   */
  async listUsers(query: ListUsersQuery): Promise<ListUsersResponse> {
    const [users, total] = await Promise.all([
      this.userRepository.findAll({
        limit: query.limit,
        offset: query.offset,
        status: query.status,
      }),
      this.userRepository.count({ status: query.status }),
    ]);

    return {
      data: users.map((user) => this.toResponse(user)),
      meta: {
        total,
        limit: query.limit,
        offset: query.offset,
      },
    };
  }

  /**
   * 사용자 업데이트
   */
  async updateUser(id: string, input: UpdateUserInput): Promise<UserResponse> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new UserNotFoundError(id);
    }

    // 이메일 변경 시 중복 확인
    if (input.email && input.email !== user.email) {
      const existing = await this.userRepository.findByEmail(input.email);
      if (existing) {
        throw new UserAlreadyExistsError(input.email);
      }
    }

    const updated = user.update(input);
    const saved = await this.userRepository.save(updated);

    return this.toResponse(saved);
  }

  /**
   * 사용자 삭제
   */
  async deleteUser(id: string): Promise<void> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new UserNotFoundError(id);
    }

    await this.userRepository.delete(id);
  }

  /**
   * Entity to Response 변환
   */
  private toResponse(user: User): UserResponse {
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      status: user.status,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    };
  }
}
