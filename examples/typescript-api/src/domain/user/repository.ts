import { User } from './entity';

/**
 * User Repository Interface
 *
 * 도메인 레이어에서 정의하는 저장소 인터페이스입니다.
 * 실제 구현은 Infrastructure 레이어에서 합니다.
 */
export interface IUserRepository {
  /**
   * ID로 사용자 조회
   */
  findById(id: string): Promise<User | null>;

  /**
   * 이메일로 사용자 조회
   */
  findByEmail(email: string): Promise<User | null>;

  /**
   * 모든 사용자 조회
   */
  findAll(options?: {
    limit?: number;
    offset?: number;
    status?: string;
  }): Promise<User[]>;

  /**
   * 사용자 저장 (생성 또는 업데이트)
   */
  save(user: User): Promise<User>;

  /**
   * 사용자 삭제
   */
  delete(id: string): Promise<void>;

  /**
   * 사용자 수 조회
   */
  count(options?: { status?: string }): Promise<number>;
}
