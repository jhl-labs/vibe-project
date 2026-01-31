import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';

/**
 * Request Body Validation Middleware
 */
export function validateBody(schema: ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      next(error);
    }
  };
}

/**
 * Request Query Validation Middleware
 */
export function validateQuery(schema: ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      // as any: Express ParsedQs 타입과 Zod 반환 타입 불일치로 불가피
      req.query = schema.parse(req.query) as any;
      next();
    } catch (error) {
      next(error);
    }
  };
}

/**
 * Request Params Validation Middleware
 */
export function validateParams(schema: ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      // as any: Express ParamsDictionary 타입과 Zod 반환 타입 불일치로 불가피
      req.params = schema.parse(req.params) as any;
      next();
    } catch (error) {
      next(error);
    }
  };
}
