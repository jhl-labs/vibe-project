/**
 * User Domain Errors
 *
 * 도메인 레이어에서 발생하는 에러들입니다.
 */

export class UserNotFoundError extends Error {
  constructor(identifier: string) {
    super(`User not found: ${identifier}`);
    this.name = 'UserNotFoundError';
  }
}

export class UserAlreadyExistsError extends Error {
  constructor(email: string) {
    super(`User with email '${email}' already exists`);
    this.name = 'UserAlreadyExistsError';
  }
}

export class InvalidUserDataError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InvalidUserDataError';
  }
}
