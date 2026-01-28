import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import {
  UserNotFoundError,
  UserAlreadyExistsError,
} from '../../domain/user/errors';

/**
 * Global Error Handler Middleware
 */
export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  console.error('Error:', error);

  // Zod Validation Error
  if (error instanceof ZodError) {
    res.status(400).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details: error.errors.map((e) => ({
          field: e.path.join('.'),
          message: e.message,
        })),
      },
    });
    return;
  }

  // Domain Errors
  if (error instanceof UserNotFoundError) {
    res.status(404).json({
      error: {
        code: 'USER_NOT_FOUND',
        message: error.message,
      },
    });
    return;
  }

  if (error instanceof UserAlreadyExistsError) {
    res.status(409).json({
      error: {
        code: 'USER_ALREADY_EXISTS',
        message: error.message,
      },
    });
    return;
  }

  // Unknown Error
  res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message:
        process.env.NODE_ENV === 'production'
          ? 'Internal server error'
          : error.message,
    },
  });
}
