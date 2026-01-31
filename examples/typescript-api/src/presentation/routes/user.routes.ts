import { Router, Request, Response, NextFunction } from 'express';
import { UserUseCases } from '../../application/user/use-cases';
import {
  createUserSchema,
  updateUserSchema,
  listUsersQuerySchema,
  ListUsersQuery,
} from '../../application/user/dto';
import { PrismaUserRepository } from '../../infrastructure/database/user-repository';
import { prisma } from '../../infrastructure/database/prisma';
import { validateBody, validateQuery } from '../middleware/validation';

const router = Router();

// Dependency injection
const userRepository = new PrismaUserRepository(prisma);
const userUseCases = new UserUseCases(userRepository);

/**
 * GET /api/users
 * 사용자 목록 조회
 */
router.get(
  '/',
  validateQuery(listUsersQuerySchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const query = req.query as unknown as ListUsersQuery;
      const result = await userUseCases.listUsers(query);
      res.json(result);
    } catch (error) {
      next(error);
    }
  }
);

/**
 * POST /api/users
 * 사용자 생성
 */
router.post(
  '/',
  validateBody(createUserSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await userUseCases.createUser(req.body);
      res.status(201).json({ data: user });
    } catch (error) {
      next(error);
    }
  }
);

/**
 * GET /api/users/:id
 * 사용자 상세 조회
 */
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userUseCases.getUser(req.params.id);
    res.json({ data: user });
  } catch (error) {
    next(error);
  }
});

/**
 * PUT /api/users/:id
 * 사용자 수정
 */
router.put(
  '/:id',
  validateBody(updateUserSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await userUseCases.updateUser(req.params.id, req.body);
      res.json({ data: user });
    } catch (error) {
      next(error);
    }
  }
);

/**
 * DELETE /api/users/:id
 * 사용자 삭제
 */
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await userUseCases.deleteUser(req.params.id);
    res.status(204).send();
  } catch (error) {
    next(error);
  }
});

export { router as userRouter };
