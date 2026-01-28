import { z } from 'zod';

/**
 * User DTOs and Validation Schemas
 */

// Create User
export const createUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  name: z.string().min(1, 'Name is required').max(100, 'Name is too long'),
});

export type CreateUserInput = z.infer<typeof createUserSchema>;

// Update User
export const updateUserSchema = z.object({
  email: z.string().email('Invalid email format').optional(),
  name: z.string().min(1).max(100).optional(),
});

export type UpdateUserInput = z.infer<typeof updateUserSchema>;

// User Response
export interface UserResponse {
  id: string;
  email: string;
  name: string;
  status: string;
  createdAt: string;
  updatedAt: string;
}

// List Users Query
export const listUsersQuerySchema = z.object({
  limit: z.coerce.number().min(1).max(100).default(20),
  offset: z.coerce.number().min(0).default(0),
  status: z.enum(['active', 'inactive', 'suspended']).optional(),
});

export type ListUsersQuery = z.infer<typeof listUsersQuerySchema>;

// List Users Response
export interface ListUsersResponse {
  data: UserResponse[];
  meta: {
    total: number;
    limit: number;
    offset: number;
  };
}
